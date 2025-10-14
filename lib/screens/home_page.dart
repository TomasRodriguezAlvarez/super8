import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> fichas = [];

  @override
  void initState() {
    super.initState();
    _cargarFichas();
  }

  Future<void> _cargarFichas() async {
    final raw = await rootBundle.loadString('assets/fichas.json');
    setState(() => fichas = json.decode(raw));
  }

  double _imc(num pesoKg, num alturaM) {
    if (alturaM == 0) return 0;
    final imc = pesoKg / (alturaM * alturaM);
    return double.parse(imc.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fichas médicas')),
      body: fichas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: fichas.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final f = fichas[i] as Map<String, dynamic>;
                final imc = _imc(f['pesoKg'], f['alturaM']);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((f['nombre'] as String).substring(0, 1)),
                  ),
                  title: Text(f['nombre']),
                  subtitle: Text(
                    '${f['rut']} • ${f['doctor']} • ${f['fechaAtencion']}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('IMC', style: TextStyle(fontSize: 11)),
                      Text('$imc', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/detalle',
                    arguments: f,
                  ),
                );
              },
            ),
    );
  }
}
