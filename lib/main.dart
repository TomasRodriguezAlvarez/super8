import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/detail_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dinos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      // Ruta inicial y rutas con nombre
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/detalle': (_) => const DetailPage(),
      },
    );
  }
}
