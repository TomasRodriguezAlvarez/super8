import 'package:flutter/material.dart';
import '../core/api.dart';
import 'ficha_form_page.dart';

class DetailPage extends StatefulWidget {
  final int pacienteId;

  const DetailPage({super.key, required this.pacienteId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _ficha;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetalle();
  }

  Future<void> _loadDetalle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // 👇 usa tu API real
      final data = await Api.getFicha(widget.pacienteId);
      setState(() {
        _ficha = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _editarFicha() async {
    if (_ficha == null) return;

    final recargar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FichaFormPage(ficha: _ficha!), // tu form de edición
      ),
    );

    if (recargar == true) {
      await _loadDetalle();        // refrescar detalle
      if (!mounted) return;
      Navigator.pop(context, true); // avisar al HomePage para que recargue lista
    }
  }

  Future<void> _eliminarFicha() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar ficha'),
        content: const Text(
            '¿Seguro que quieres eliminar esta ficha y el paciente asociado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await Api.deleteFicha(widget.pacienteId);
        if (!mounted) return;
        Navigator.pop(context, true); // volver a la lista y recargar
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error eliminando ficha: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha médica'),
        actions: [
          IconButton(
            tooltip: 'Editar ficha',
            icon: const Icon(Icons.edit),
            onPressed: _ficha == null ? null : _editarFicha,
          ),
          IconButton(
            tooltip: 'Eliminar ficha',
            icon: const Icon(Icons.delete),
            onPressed: _eliminarFicha,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _ficha == null
                  ? const Center(child: Text('Ficha no encontrada'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre grande
                          Text(
                            '${_ficha!['nombres']} ${_ficha!['apellidos']}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Identificación: ${_ficha!['numero_identificacion']}',
                          ),
                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                avatar: const Icon(Icons.person, size: 18),
                                label: Text(
                                    'Género: ${_ficha!['genero'] ?? '-'}'),
                              ),
                              Chip(
                                avatar:
                                    const Icon(Icons.bloodtype, size: 18),
                                label: Text(
                                    'Sangre: ${_ficha!['tipo_sangre'] ?? '-'}'),
                              ),
                              Chip(
                                avatar:
                                    const Icon(Icons.folder_open, size: 18),
                                label: Text(
                                    'Ficha: ${_ficha!['numero_ficha'] ?? '-'}'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Datos de contacto
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contacto',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: color.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Email: ${_ficha!['email'] ?? '-'}'),
                                  Text(
                                      'Teléfono: ${_ficha!['telefono'] ?? '-'}'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Alergias / condiciones
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alergias',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: color.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _ficha!['alergias']?.toString().isNotEmpty ==
                                            true
                                        ? _ficha!['alergias'].toString()
                                        : 'Sin alergias registradas',
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Condiciones crónicas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: color.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _ficha!['condiciones_cronicas']
                                                ?.toString()
                                                .isNotEmpty ==
                                            true
                                        ? _ficha!['condiciones_cronicas']
                                            .toString()
                                        : 'Sin condiciones registradas',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
