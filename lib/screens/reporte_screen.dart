import 'package:flutter/material.dart';

import '../models/estudiante.dart';
import '../services/asistencia_service.dart';

class ReporteScreen extends StatefulWidget {
  final AsistenciaService servicio;
  final String aulaCodigo;

  const ReporteScreen({
    super.key,
    required this.servicio,
    required this.aulaCodigo,
  });

  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  static const morado = Color(0xFF60358C);
  static const texto = Color(0xFF352447);

  String _periodo = 'Hoy';

  Widget _tarjeta(String titulo, int cantidad, Color color, IconData icono) {
    return Expanded(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
          child: Column(
            children: [
              Icon(icono, color: color),
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
              Text(titulo, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _celda(String contenido, {bool titulo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Text(
        contenido,
        style: TextStyle(
          fontSize: titulo ? 12 : 12.5,
          fontWeight: titulo ? FontWeight.bold : FontWeight.normal,
          color: texto,
        ),
      ),
    );
  }

  String _porcentajeEstudiante(Estudiante estudiante) {
    switch (estudiante.estado) {
      case EstadoAsistencia.presente:
      case EstadoAsistencia.tardanza:
        return '100%';

      case EstadoAsistencia.falta:
        return '0%';

      case EstadoAsistencia.sinRegistrar:
        return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final aulas = widget.servicio.obtenerAulas();

    final aulaEncontrada = aulas
        .where((aula) => aula.codigo == widget.aulaCodigo)
        .toList();

    final nombreAula = aulaEncontrada.isEmpty
        ? widget.aulaCodigo
        : aulaEncontrada.first.nombre;

    final resumen = widget.servicio.obtenerResumenEstadistico(
      aulaCodigo: widget.aulaCodigo,
    );

    final estudiantes = widget.servicio.obtenerTodos(
      aulaCodigo: widget.aulaCodigo,
    );

    final presentes = resumen['presentes'] as int;
    final tardanzas = resumen['tardanzas'] as int;
    final faltas = resumen['faltas'] as int;
    final sinRegistrar = resumen['sinRegistrar'] as int;

    final porcentaje = widget.servicio.calcularPorcentajeAsistencia(
      aulaCodigo: widget.aulaCodigo,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Reporte de asistencia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),

        const SizedBox(height: 18),

        // AULA Y PERIODO
        Row(
          children: [
            Expanded(
              child: Text(
                nombreAula,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: morado,
                ),
              ),
            ),

            SizedBox(
              width: 165,
              child: DropdownButtonFormField<String>(
                value: _periodo,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Periodo',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: ['Hoy', 'Esta semana', 'Este mes'].map((periodo) {
                  return DropdownMenuItem(
                    value: periodo,
                    child: Text(periodo, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => _periodo = valor);
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (_periodo != 'Hoy')
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: morado,
                    size: 40,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Reporte: $_periodo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Todavía no hay un historial de '
                    'asistencias por fecha en el backend. '
                    'Cuando se incorpore, aquí aparecerán '
                    'los porcentajes del periodo seleccionado.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else ...[
          // ESTADÍSTICAS DE LA JORNADA
          Row(
            children: [
              _tarjeta(
                'Presentes',
                presentes,
                Colors.green,
                Icons.check_circle_outline,
              ),
              _tarjeta(
                'Tardanzas',
                tardanzas,
                Colors.orange,
                Icons.access_time,
              ),
              _tarjeta('Faltas', faltas, Colors.red, Icons.cancel_outlined),
            ],
          ),

          if (sinRegistrar > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '$sinRegistrar estudiante(s) aún sin guardar. '
                'El porcentaje puede cambiar cuando se '
                'complete el registro.',
                style: const TextStyle(fontSize: 12, color: Colors.deepOrange),
              ),
            ),

          const SizedBox(height: 22),

          // PORCENTAJE GENERAL
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
                  const SizedBox(height: 18),
                  Text(
                    '${porcentaje.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: morado,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: porcentaje / 100,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(10),
                    color: morado,
                    backgroundColor: const Color(0xFFE2D6EB),
                  ),
                  const SizedBox(height: 12),
                  Text('Total: ${estudiantes.length} estudiantes'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Asistencia por estudiante',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),

          const SizedBox(height: 12),

          // TABLA DE PORCENTAJES
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6DDF0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(66),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(85),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Color(0xFFEDE5F1)),
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFE9DDF4)),
                    children: [
                      _celda('Código', titulo: true),
                      _celda('Nombre completo', titulo: true),
                      _celda('Asist. %', titulo: true),
                    ],
                  ),

                  ...estudiantes.map((estudiante) {
                    return TableRow(
                      children: [
                        _celda(estudiante.codigo),
                        _celda(
                          '${estudiante.nombre} '
                          '${estudiante.apellido}',
                        ),
                        _celda(_porcentajeEstudiante(estudiante)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
