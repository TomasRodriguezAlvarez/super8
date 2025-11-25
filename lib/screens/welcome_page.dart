import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.primary.withOpacity(0.1),
              color.secondary.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: color.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.local_hospital,
                        size: 40,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'MedicEight',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestión simple de fichas médicas',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar sesión'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Registrarse'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Demo académica - datos simulados',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: color.outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
