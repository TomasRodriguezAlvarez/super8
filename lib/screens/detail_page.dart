import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final nombre = args?['nombre'] ?? 'Desconocido';
    final pesoTon = args?['pesoTon'] ?? '?';
    final largoM = args?['largoM'] ?? '?';
    final periodo = args?['periodo'] ?? '---';
    final dieta = args?['dieta'] ?? '---';

    return Scaffold(
      appBar: AppBar(title: Text(nombre.toString())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Icon(Icons.grass, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text('Dieta: $dieta'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.brown[700]),
                const SizedBox(width: 8),
                Text('Período: $periodo'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.straighten, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text('Largo: $largoM m'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.red[700]),
                const SizedBox(width: 8),
                Text('Peso: $pesoTon toneladas'),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              'El $nombre fue uno de los dinosaurios más conocidos del periodo $periodo. '
              'Su dieta era principalmente $dieta y alcanzaba hasta $largoM metros de largo. '
              'Pesaba alrededor de $pesoTon toneladas.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
