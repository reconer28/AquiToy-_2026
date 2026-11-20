import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

class MiCuentaScreen extends StatefulWidget {
  final String nombreDocente;
  final ValueChanged<String> onCambiarNombre;

  const MiCuentaScreen({
    super.key,
    required this.nombreDocente,
    required this.onCambiarNombre,
  });

  @override
  State<MiCuentaScreen> createState() => _MiCuentaScreenState();
}

class _MiCuentaScreenState extends State<MiCuentaScreen> {
  final _nombreController = TextEditingController();
  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _confirmarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreDocente;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _actualController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _guardarNombre() {
    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      _mensaje('Ingresa el nombre del docente.');
      return;
    }

    widget.onCambiarNombre(nombre);
    _mensaje('Nombre actualizado en esta sesión.');
  }

  void _cambiarContrasena() {
    if (_actualController.text.isEmpty) {
      _mensaje('Ingresa tu contraseña actual.');
      return;
    }

    if (_nuevaController.text.length < 6) {
      _mensaje('La nueva contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (_nuevaController.text != _confirmarController.text) {
      _mensaje('Las contraseñas nuevas no coinciden.');
      return;
    }

    _actualController.clear();
    _nuevaController.clear();
    _confirmarController.clear();

    _mensaje(
      'Formulario válido. El cambio real de contraseña '
      'requiere conectar la autenticación.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Mi cuenta',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.texto,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Administra tus datos personales.'),
        const SizedBox(height: 24),

        // CAMBIAR NOMBRE
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre del docente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardarNombre,
                    child: const Text('Guardar nombre'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // CAMBIAR CONTRASEÑA
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cambiar contraseña',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _actualController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña actual',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _nuevaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nueva contraseña',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _confirmarController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar nueva contraseña',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cambiarContrasena,
                    child: const Text('Cambiar contraseña'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
