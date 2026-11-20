import 'package:flutter/material.dart';

import '../services/asistencia_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const morado = Color(0xFF60358C);
  static const dorado = Color(0xFFF5BC51);
  static const texto = Color(0xFF352447);

  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();

  bool _mostrarContrasena = false;
  bool _cargando = false;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) return;

    final servicio = AsistenciaService();

    // Buscar docente en el backend.
    final docente = servicio.buscarDocentePorCorreo(_correo.text.trim());

    if (docente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo de docente no registrado.')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      // Cargar los 20 estudiantes del backend.
      await servicio.cargarEstudiantes();

      if (!mounted) return;

      // Enviar el mismo servicio a HomeScreen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(servicio: servicio, docente: docente),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar los datos: $e')));
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EDFA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(35),
                    decoration: const BoxDecoration(
                      color: morado,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: dorado,
                          child: Icon(Icons.school, size: 40, color: texto),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'AquiToy!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Control de asistencia estudiantil',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                '¡Bienvenido, docente!',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: texto,
                                ),
                              ),
                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _correo,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Correo institucional',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (valor) {
                                  if (valor == null || valor.trim().isEmpty) {
                                    return 'Ingresa tu correo';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 18),

                              TextFormField(
                                controller: _contrasena,
                                obscureText: !_mostrarContrasena,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _mostrarContrasena
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _mostrarContrasena =
                                            !_mostrarContrasena;
                                      });
                                    },
                                  ),
                                ),
                                validator: (valor) {
                                  if (valor == null || valor.isEmpty) {
                                    return 'Ingresa una contraseña';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              ElevatedButton(
                                onPressed: _cargando ? null : _ingresar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: dorado,
                                  foregroundColor: texto,
                                  minimumSize: const Size.fromHeight(52),
                                ),
                                child: _cargando
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Ingresar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                'Acceso de demostración: '
                                'se comprueba el correo del docente, '
                                'pero no su contraseña.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
