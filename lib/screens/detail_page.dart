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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await Api.getFicha(widget.pacienteId);
      setState(() => _ficha = data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _eliminar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar ficha'),
        content: const Text('¿Seguro que deseas eliminar este paciente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await Api.deleteFicha(widget.pacienteId);
      if (mounted) Navigator.pop(context, true); // volver y recargar lista
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = _ficha;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha médica'),
        actions: f == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final recargar = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FichaFormPage(ficha: f),
                      ),
                    );
                    if (recargar == true) {
                      _load();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _eliminar,
                ),
              ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : f == null
              ? const Center(child: Text('No se encontró la ficha'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${f['nombres']} ${f['apellidos']}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Identificación: ${f['numero_identificacion'] ?? ''}'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('Género: ${f['genero'] ?? '-'}')),
                          Chip(
                              label:
                                  Text('Sangre: ${f['tipo_sangre'] ?? '-'}')),
                          Chip(
                              label:
                                  Text('Email: ${f['email'] ?? 'sin email'}')),
                          Chip(
                              label: Text(
                                  'Tel: ${f['telefono'] ?? 'sin teléfono'}')),
                          Chip(
                              label: Text(
                                  'Ficha: ${f['numero_ficha'] ?? 'sin ficha'}')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Consultas recientes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: (f['consultas'] as List).isEmpty
                            ? const Text('Sin consultas registradas.')
                            : ListView.builder(
                                itemCount: (f['consultas'] as List).length,
                                itemBuilder: (context, i) {
                                  final c = (f['consultas'] as List)[i];
                                  return ListTile(
                                    title: Text(
                                        c['motivo']?.toString() ?? 'Consulta'),
                                    subtitle: Text(
                                        c['fecha_consulta']?.toString() ?? ''),
                                    trailing: Text(c['estado']?.toString() ?? ''),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Volver'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
