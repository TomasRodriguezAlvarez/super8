import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/auth_service.dart';
import 'detail_page.dart';
import 'ficha_form_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Datos
  List<dynamic> _allFichas = [];
  List<dynamic> _filteredFichas = [];

  bool _loading = true;
  String _search = '';

  // Filtros avanzados
  bool _showFilters = false;
  String _filtroGenero = 'Todos';
  String _filtroSangre = 'Todos';
  RangeValues _rangoEdad = const RangeValues(0, 120);

  final Set<String> _tiposSangre = {};

  @override
  void initState() {
    super.initState();

    final user = AuthService.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
      return;
    }

    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await Api.getFichas(search: _search);
      _allFichas = data;

      _tiposSangre
        ..clear()
        ..addAll(_allFichas
            .map((f) => (f['tipo_sangre'] ?? '').toString())
            .where((s) => s.isNotEmpty));

      _aplicarFiltros();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _aplicarFiltros() {
    List<dynamic> lista = List.from(_allFichas);

    // Género
    if (_filtroGenero != 'Todos') {
      final buscado = _filtroGenero.toLowerCase();
      lista = lista
          .where((f) =>
              (f['genero'] ?? '').toString().toLowerCase() == buscado)
          .toList();
    }

    // Sangre
    if (_filtroSangre != 'Todos') {
      lista = lista
          .where((f) =>
              (f['tipo_sangre'] ?? '').toString() == _filtroSangre)
          .toList();
    }

    // Edad
    lista = lista.where((f) {
      final edad = f['edad'];
      if (edad == null) return true;
      final numEdad = edad is int ? edad : int.tryParse(edad.toString());
      if (numEdad == null) return true;
      return numEdad >= _rangoEdad.start && numEdad <= _rangoEdad.end;
    }).toList();

    setState(() {
      _filteredFichas = lista;
    });
  }

  void _limpiarFiltros() {
    setState(() {
      _filtroGenero = 'Todos';
      _filtroSangre = 'Todos';
      _rangoEdad = const RangeValues(0, 120);
    });
    _aplicarFiltros();
  }

  @override
  Widget build(BuildContext context) {
    final fichas = _filteredFichas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fichas médicas'),
        actions: [
          // 👇 Botón modo oscuro / claro
          IconButton(
            tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo oscuro',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.instance.logout();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nombre o identificación...',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                _search = v;
                _load();
              },
            ),
          ),

          // Toggle filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() => _showFilters = !_showFilters);
                  },
                  icon: Icon(
                    _showFilters ? Icons.filter_alt_off : Icons.filter_alt,
                  ),
                  label: Text(
                    _showFilters
                        ? 'Ocultar filtros avanzados'
                        : 'Filtros avanzados',
                  ),
                ),
                const Spacer(),
                if (_showFilters)
                  TextButton(
                    onPressed: _limpiarFiltros,
                    child: const Text('Limpiar filtros'),
                  ),
              ],
            ),
          ),

          if (_showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Género
                      Row(
                        children: [
                          const Text('Género:'),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: _filtroGenero,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Todos', child: Text('Todos')),
                              DropdownMenuItem(
                                  value: 'masculino',
                                  child: Text('Masculino')),
                              DropdownMenuItem(
                                  value: 'femenino', child: Text('Femenino')),
                              DropdownMenuItem(
                                  value: 'otro', child: Text('Otro')),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _filtroGenero = value);
                              _aplicarFiltros();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Sangre
                      Row(
                        children: [
                          const Text('Tipo de sangre:'),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: _filtroSangre,
                            items: [
                              const DropdownMenuItem(
                                  value: 'Todos', child: Text('Todos')),
                              ..._tiposSangre.map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _filtroSangre = value);
                              _aplicarFiltros();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Edad
                      const Text('Rango de edad (años):'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_rangoEdad.start.round()}'),
                          Expanded(
                            child: RangeSlider(
                              values: _rangoEdad,
                              divisions: 120,
                              min: 0,
                              max: 120,
                              labels: RangeLabels(
                                _rangoEdad.start.round().toString(),
                                _rangoEdad.end.round().toString(),
                              ),
                              onChanged: (values) {
                                setState(() => _rangoEdad = values);
                                _aplicarFiltros();
                              },
                            ),
                          ),
                          Text('${_rangoEdad.end.round()}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Lista
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : fichas.isEmpty
                    ? const Center(child: Text('No se encontraron fichas.'))
                    : ListView.separated(
                        itemCount: fichas.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, i) {
                          final f = fichas[i];
                          final nombre = f['nombre_completo'] ?? 'Sin nombre';
                          final id = f['id'] as int;
                          final rut = f['numero_identificacion'] ?? '';
                          final ficha = f['numero_ficha'] ?? '-';
                          final edad = f['edad'];
                          final genero = (f['genero'] ?? '').toString();
                          final sangre = (f['tipo_sangre'] ?? '').toString();
                          
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  nombre.toString().isNotEmpty ? nombre.toString()[0] : '?',
                                ),
                              ),
                              title: Text(nombre.toString()),
                              subtitle: Text(
                                '$rut · Ficha: $ficha\n'
                                '${genero.isNotEmpty ? 'Género: $genero · ' : ''}'
                                '${sangre.isNotEmpty ? 'Sangre: $sangre' : ''}',
                              ),
                              isThreeLine: true,
                              trailing: Text(
                                (edad != null && edad.toString().isNotEmpty) ? 'Edad\n$edad' : '',
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final recargar = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(pacienteId: id),
                                  ),
                                );
                                if (recargar == true) {
                                  _load();
                                }
                              },
                            ),
                          );

                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final recargar = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FichaFormPage()),
          );
          if (recargar == true) {
            _load();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
