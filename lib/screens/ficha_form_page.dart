import 'package:flutter/material.dart';
import '../core/api.dart';

class FichaFormPage extends StatefulWidget {
  final Map<String, dynamic>? ficha; // null => crear

  const FichaFormPage({super.key, this.ficha});

  @override
  State<FichaFormPage> createState() => _FichaFormPageState();
}

class _FichaFormPageState extends State<FichaFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombres;
  late final TextEditingController _apellidos;
  late final TextEditingController _ident;
  late final TextEditingController _genero;
  late final TextEditingController _sangre;
  late final TextEditingController _email;
  late final TextEditingController _telefono;
  late final TextEditingController _fechaNac;
  late final TextEditingController _numeroFicha;
  late final TextEditingController _alergias;
  late final TextEditingController _condiciones;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final f = widget.ficha;

    _nombres = TextEditingController(text: f?['nombres']?.toString() ?? '');
    _apellidos = TextEditingController(text: f?['apellidos']?.toString() ?? '');
    _ident =
        TextEditingController(text: f?['numero_identificacion']?.toString() ?? '');
    _genero = TextEditingController(text: f?['genero']?.toString() ?? '');
    _sangre = TextEditingController(text: f?['tipo_sangre']?.toString() ?? '');
    _email = TextEditingController(text: f?['email']?.toString() ?? '');
    _telefono = TextEditingController(text: f?['telefono']?.toString() ?? '');
    _fechaNac =
        TextEditingController(text: f?['fecha_nacimiento']?.toString() ?? '');
    _numeroFicha =
        TextEditingController(text: f?['numero_ficha']?.toString() ?? '');
    _alergias = TextEditingController(text: f?['alergias']?.toString() ?? '');
    _condiciones =
        TextEditingController(text: f?['condiciones_cronicas']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _ident.dispose();
    _genero.dispose();
    _sangre.dispose();
    _email.dispose();
    _telefono.dispose();
    _fechaNac.dispose();
    _numeroFicha.dispose();
    _alergias.dispose();
    _condiciones.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final rawDate = _fechaNac.text.trim();
    final cleanedDate = rawDate.contains('T') ? rawDate.split('T').first : rawDate;

    final data = {
      'nombres': _nombres.text,
      'apellidos': _apellidos.text,
      'numero_identificacion': _ident.text,
      'genero': _genero.text,
      'tipo_sangre': _sangre.text,
      'email': _email.text,
      'telefono': _telefono.text,
      'fecha_nacimiento': cleanedDate.isEmpty ? null : cleanedDate,
      'numero_ficha': _numeroFicha.text,
      'alergias': _alergias.text,
      'condiciones_cronicas': _condiciones.text,
    };

    try {
      if (widget.ficha == null) {
        await Api.createFicha(data);
      } else {
        final id = widget.ficha!['paciente_id'] ??
            widget.ficha!['id']; // depende de lo que te llegó
        await Api.updateFicha(id as int, data);
      }
      if (mounted) Navigator.pop(context, true); // true => recargar lista
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.ficha != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar ficha' : 'Nueva ficha'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombres,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _apellidos,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              TextFormField(
                controller: _ident,
                decoration:
                    const InputDecoration(labelText: 'Número identificación'),
              ),
              TextFormField(
                controller: _genero,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
              TextFormField(
                controller: _sangre,
                decoration: const InputDecoration(labelText: 'Tipo de sangre'),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextFormField(
                controller: _fechaNac,
                decoration: const InputDecoration(
                    labelText: 'Fecha nacimiento (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _numeroFicha,
                decoration: const InputDecoration(labelText: 'Número ficha'),
              ),
              TextFormField(
                controller: _alergias,
                decoration: const InputDecoration(labelText: 'Alergias'),
              ),
              TextFormField(
                controller: _condiciones,
                decoration:
                    const InputDecoration(labelText: 'Condiciones crónicas'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _guardar,
                child: Text(_saving
                    ? 'Guardando...'
                    : (editando ? 'Guardar cambios' : 'Crear')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
