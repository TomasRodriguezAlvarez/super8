import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  /// Alterna entre tema claro <-> oscuro
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark;

    return MaterialApp(
      title: 'MedicEight',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // 🌞 Tema claro bonito
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),

      // 🌙 Tema oscuro elegante
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),


      initialRoute: '/welcome',

      routes: {
        '/welcome': (_) => const WelcomePage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),

        // 👇 Pasamos el callback y el estado del tema a HomePage
        '/home': (_) => HomePage(
              onToggleTheme: _toggleTheme,
              isDarkMode: isDark,
            ),
      },
    );
  }
}
