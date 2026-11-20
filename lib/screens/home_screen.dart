import 'package:flutter/material.dart';

import '../models/docente.dart';
import '../services/asistencia_service.dart';

import 'login_screen.dart';
import 'asistencia_screen.dart';
import 'reporte_screen.dart';
import 'micuenta_screen.dart';

class HomeScreen extends StatefulWidget {
  final AsistenciaService servicio;
  final Docente docente;

  const HomeScreen({super.key, required this.servicio, required this.docente});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const morado = Color(0xFF60358C);
  static const dorado = Color(0xFFF5BC51);

  int _pagina = 0;

  late String _aulaActual;
  late String _nombreDocente;

  @override
  void initState() {
    super.initState();

    // Aula asignada al docente.
    _aulaActual = widget.docente.aulaCodigo;

    _nombreDocente = '${widget.docente.nombre} ${widget.docente.apellido}';
  }

  // Actualizar interfaz después de guardar.
  void _actualizarAsistencia() {
    setState(() {});
  }

  // CERRAR SESIÓN
  void _cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: morado,
        foregroundColor: Colors.white,

        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, color: dorado, size: 23),
            SizedBox(width: 8),
            Text(
              'AquiToy!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // BOTÓN PEQUEÑO CERRAR SESIÓN
        actions: [
          TextButton.icon(
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Cerrar sesión', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),

      // NAVEGACIÓN ENTRE PANTALLAS
      body: IndexedStack(
        index: _pagina,
        children: [
          AsistenciaScreen(
            servicio: widget.servicio,
            aulaActual: _aulaActual,
            onCambiarAula: (codigo) {
              setState(() {
                _aulaActual = codigo;
              });
            },
            onActualizado: _actualizarAsistencia,
          ),

          ReporteScreen(servicio: widget.servicio, aulaCodigo: _aulaActual),

          MiCuentaScreen(
            nombreDocente: _nombreDocente,
            onCambiarNombre: (nombre) {
              setState(() {
                _nombreDocente = nombre;
              });
            },
          ),
        ],
      ),

      // MENÚ INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pagina,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: morado,
        unselectedItemColor: Colors.grey,

        onTap: (indice) {
          setState(() {
            _pagina = indice;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            activeIcon: Icon(Icons.fact_check),
            label: 'Asistencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Mi cuenta',
          ),
        ],
      ),
    );
  }
}
