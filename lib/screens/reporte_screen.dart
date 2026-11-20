import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

class ReporteScreen extends StatelessWidget {
  final List<Map<String, String>> estudiantes;
  final String aulaActual;

  const ReporteScreen({
    super.key,
    required this.estudiantes,
    required this.aulaActual,
  });

  Widget _tarjeta(String titulo, int cantidad, Color color, IconData icono) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
          child: Column(
            children: [
              Icon(icono, color: color, size: 28),
              const SizedBox(height: 10),
              Text(
                '$cantidad',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alumnos = estudiantes.where((e) => e['aula'] == aulaActual).toList();

    final presentes = alumnos.where((e) => e['estado'] == 'Presente').length;

    final tardanzas = alumnos.where((e) => e['estado'] == 'Tardanza').length;

    final faltas = alumnos.where((e) => e['estado'] == 'Falta').length;

    final porcentaje = alumnos.isEmpty
        ? 0.0
        : (presentes + tardanzas) / alumnos.length * 100;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Reporte de asistencia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.texto,
          ),
        ),
        const SizedBox(height: 8),
        Text('Aula: $aulaActual', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 25),

        Row(
          children: [
            _tarjeta('Presentes', presentes, Colors.green, Icons.check_circle),
            _tarjeta('Tardanzas', tardanzas, Colors.orange, Icons.access_time),
            _tarjeta('Faltas', faltas, Colors.red, Icons.cancel),
          ],
        ),

        const SizedBox(height: 24),

        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Porcentaje de asistencia',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  '${porcentaje.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secundario,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: porcentaje / 100,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.secundario,
                  backgroundColor: const Color(0xFFE2D6EB),
                ),
                const SizedBox(height: 14),
                Text(
                  '${presentes + tardanzas} de '
                  '${alumnos.length} estudiantes asistieron',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.groups, color: AppTheme.secundario),
            title: const Text('Total de estudiantes'),
            trailing: Text(
              '${alumnos.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
