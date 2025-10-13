import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dinos = [
      {
        'nombre': 'Tyrannosaurus Rex',
        'pesoTon': 9.0,
        'largoM': 12.0,
        'periodo': 'Cretácico tardío',
        'dieta': 'Carnívoro',
      },
      {
        'nombre': 'Triceratops',
        'pesoTon': 6.0,
        'largoM': 9.0,
        'periodo': 'Cretácico tardío',
        'dieta': 'Herbívoro',
      },
      {
        'nombre': 'Velociraptor',
        'pesoTon': 0.015,
        'largoM': 2.0,
        'periodo': 'Cretácico tardío',
        'dieta': 'Carnívoro',
      },
      {
        'nombre': 'Brachiosaurus',
        'pesoTon': 56.0,
        'largoM': 25.0,
        'periodo': 'Jurásico superior',
        'dieta': 'Herbívoro',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dinosaurios')),
      body: ListView.separated(
        itemCount: dinos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final dino = dinos[i];
          return ListTile(
            leading: CircleAvatar(
              child: Text((dino['nombre'] as String)[0]),
            ),
            title: Text(dino['nombre'] as String),
            subtitle: Text('${dino['dieta']} • ${dino['periodo']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/detalle', arguments: dino);
            },
          );
        },
      ),
    );
  }
}
