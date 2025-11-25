import 'package:flutter/material.dart';
import '../core/api.dart';
import 'detail_page.dart';
import 'ficha_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _fichas = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await Api.getFichas(search: _search);
      setState(() => _fichas = data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fichas médicas')),
      body: Column(
        children: [
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
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _fichas.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final f = _fichas[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            (f['nombre_completo'] ?? 'N')[0],
                          ),
                        ),
                        title: Text(f['nombre_completo'] ?? 'Sin nombre'),
                        subtitle: Text(
                            '${f['numero_identificacion'] ?? ''} • Ficha: ${f['numero_ficha'] ?? '-'}'),
                        trailing: Text(
                          (f['edad']?.toString() ?? '') != ''
                              ? 'Edad\n${f['edad']}'
                              : '',
                          textAlign: TextAlign.right,
                        ),
                        onTap: () async {
                          final id = f['id'] as int;
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
