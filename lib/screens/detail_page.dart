import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../models/ficha.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<FichaDetalle> _future;

  Future<FichaDetalle> _load(int id) async {
    final raw = await Api.fichaDetalle(id);
    return FichaDetalle.fromJson(raw);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _future = _load(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha médica')),
      body: FutureBuilder<FichaDetalle>(
        future: _future,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final f = snap.data!;
          List<String> alergias = [];
          List<String> preexist = [];
          try {
            final a = f.alergiasJson != null ? json.decode(f.alergiasJson!) : [];
            final p = f.condicionesJson != null ? json.decode(f.condicionesJson!) : [];
            alergias = (a as List).map((e) => (e['alergia'] ?? e.toString()).toString()).toList();
            preexist = (p as List).map((e) => (e['condicion'] ?? e.toString()).toString()).toList();
          } catch (_) {}

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.nombreCompleto, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Identificación: ${f.numeroIdentificacion}'),
                const SizedBox(height: 4),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  Chip(label: Text('Género: ${f.genero}')),
                  Chip(label: Text('Sangre: ${f.tipoSangre}')),
                  if (f.email != null) Chip(label: Text('Email: ${f.email}')),
                  if (f.telefono != null) Chip(label: Text('Tel: ${f.telefono}')),
                  Chip(label: Text('Ficha: ${f.numeroFicha}')),
                ]),
                const SizedBox(height: 16),
                if (alergias.isNotEmpty)
                  _Section(title: 'Alergias', child: _BulletList(items: alergias)),
                if (preexist.isNotEmpty)
                  _Section(title: 'Preexistencias', child: _BulletList(items: preexist)),
                _Section(
                  title: 'Consultas recientes',
                  child: f.consultas.isEmpty
                      ? const Text('Sin consultas registradas.')
                      : Column(
                          children: f.consultas.map((c) {
                            final fecha = c['fecha_consulta']?.toString() ?? '';
                            final motivo = c['motivo']?.toString() ?? '';
                            final estado = c['estado']?.toString() ?? '';
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.event_note),
                              title: Text(motivo),
                              subtitle: Text(fecha),
                              trailing: Chip(label: Text(estado)),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(e)),
                ],
              ))
          .toList(),
    );
  }
}
