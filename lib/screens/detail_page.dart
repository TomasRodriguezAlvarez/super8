import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final f = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?) ?? {};
    double imc(num pesoKg, num alturaM) =>
        alturaM == 0 ? 0 : double.parse((pesoKg / (alturaM * alturaM)).toStringAsFixed(1));

    final chips = <Widget>[
      _Chip(label: 'Edad: ${f['edad']}'),
      _Chip(label: 'Sexo: ${f['sexo']}'),
      _Chip(label: 'Altura: ${f['alturaM']} m'),
      _Chip(label: 'Peso: ${f['pesoKg']} kg'),
      _Chip(label: 'IMC: ${imc(f['pesoKg'] ?? 0, f['alturaM'] ?? 0)}'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(f['nombre'] ?? 'Ficha médica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Datos del paciente',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['nombre'] ?? '', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text('RUT: ${f['rut'] ?? '-'}'),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: chips),
                ],
              ),
            ),
            _Section(
              title: 'Atención',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(icon: Icons.person, text: 'Doctor/a: ${f['doctor']}'),
                  _Row(icon: Icons.local_hospital, text: 'Especialidad: ${f['especialidad']}'),
                  _Row(icon: Icons.event, text: 'Fecha: ${f['fechaAtencion']}'),
                  _Row(icon: Icons.assignment, text: 'Diagnóstico: ${f['diagnostico']}'),
                ],
              ),
            ),
            if ((f['medicamentos'] as List?)?.isNotEmpty ?? false)
              _Section(
                title: 'Medicamentos',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (f['medicamentos'] as List)
                      .map<Widget>((m) => _Chip(label: m.toString()))
                      .toList(),
                ),
              ),
            if ((f['alergias'] as List?)?.isNotEmpty ?? false)
              _Section(
                title: 'Alergias',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (f['alergias'] as List)
                      .map<Widget>((a) => _Chip(label: a.toString(), icon: Icons.warning_amber))
                      .toList(),
                ),
              ),
            if ((f['preexistencias'] as List?)?.isNotEmpty ?? false)
              _Section(
                title: 'Preexistencias',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (f['preexistencias'] as List)
                      .map<Widget>((p) => _Chip(label: p.toString()))
                      .toList(),
                ),
              ),
            if ((f['notas'] as String?)?.isNotEmpty ?? false)
              _Section(
                title: 'Notas',
                child: Text(f['notas']),
              ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ]),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _Chip({required this.label, this.icon});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null ? Icon(icon, size: 18) : null,
      label: Text(label),
    );
  }
}
