class AppUser {
  final String nombre;
  final String email;
  final String password;

  AppUser({
    required this.nombre,
    required this.email,
    required this.password,
  });
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final List<AppUser> _usuarios = [
    AppUser(
      nombre: 'Usuario Demo',
      email: 'demo@mediceight.cl',
      password: '1234',
    ),
  ];

  AppUser? currentUser;

  String? register({
    required String nombre,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (nombre.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      return 'Todos los campos son obligatorios';
    }

    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }

    final existe = _usuarios.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (existe) {
      return 'Ya existe un usuario con ese correo';
    }

    final nuevo = AppUser(
      nombre: nombre.trim(),
      email: email.trim(),
      password: password,
    );
    _usuarios.add(nuevo);
    currentUser = nuevo;
    return null;
  }

  String? login(String email, String password) {
    final user = _usuarios.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => AppUser(nombre: '', email: '', password: ''),
    );

    if (user.nombre.isEmpty) {
      return 'Usuario no encontrado';
    }
    if (user.password != password) {
      return 'Contraseña incorrecta';
    }

    currentUser = user;
    return null;
  }

  void logout() {
    currentUser = null;
  }
}
