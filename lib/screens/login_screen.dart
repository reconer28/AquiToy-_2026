import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _mostrarContrasena = false;

  void _ingresar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  InputDecoration _decoracion(String texto, IconData icono, {Widget? sufijo}) {
    return InputDecoration(
      hintText: texto,
      prefixIcon: Icon(icono, color: AppTheme.secundario),
      suffixIcon: sufijo,
      filled: true,
      fillColor: const Color(0xFFFAF8FC),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD9CBE8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.secundario, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  // ENCABEZADO INSTITUCIONAL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 65),
                    decoration: const BoxDecoration(
                      color: AppTheme.secundario,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: AppTheme.acento,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 42,
                            color: AppTheme.texto,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'AquiToy!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tu aula, organizada en un solo lugar',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // FORMULARIO DE INICIO DE SESIÓN
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: AppTheme.secundario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.texto,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Ingresa tus datos para gestionar '
                                  'la asistencia de tus estudiantes.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // CORREO ELECTRÓNICO
                                const Text(
                                  'Correo electrónico',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.texto,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: _decoracion(
                                    'docente@institucion.edu.pe',
                                    Icons.email_outlined,
                                  ),
                                  validator: (valor) {
                                    if (valor == null || valor.trim().isEmpty) {
                                      return 'Ingresa tu correo';
                                    }
                                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                        .hasMatch(valor.trim())) {
                                      return 'Ingresa un correo válido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // CONTRASEÑA
                                const Text(
                                  'Contraseña',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.texto,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  obscureText: !_mostrarContrasena,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _ingresar(),
                                  decoration: _decoracion(
                                    'Ingresa tu contraseña',
                                    Icons.lock_outline,
                                    sufijo: IconButton(
                                      tooltip: _mostrarContrasena
                                          ? 'Ocultar contraseña'
                                          : 'Mostrar contraseña',
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
                                      return 'Ingresa tu contraseña';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),

                                // BOTÓN DE INGRESO
                                ElevatedButton(
                                  onPressed: _ingresar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.acento,
                                    foregroundColor: AppTheme.texto,
                                    minimumSize: const Size.fromHeight(54),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Ingresar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  '¿Problemas para ingresar?\n'
                                  'Contacta a administración.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PIE DE PANTALLA
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: AppTheme.secundario,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Acceso exclusivo para docentes',
                          style: TextStyle(
                            color: AppTheme.secundario,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
