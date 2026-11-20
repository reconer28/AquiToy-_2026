import 'package:flutter/material.dart';

import '../models/estudiante.dart';
import '../services/asistencia_service.dart';

class AsistenciaScreen extends StatefulWidget {
  final AsistenciaService servicio;
  final String aulaActual;
  final ValueChanged<String> onCambiarAula;
  final VoidCallback onActualizado;

  const AsistenciaScreen({
    super.key,
    required this.servicio,
    required this.aulaActual,
    required this.onCambiarAula,
    required this.onActualizado,
  });

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  static const morado = Color(0xFF60358C);
  static const dorado = Color(0xFFF5BC51);
  static const texto = Color(0xFF352447);

  late String _aulaElegida;

  String _filtro = 'Todos';
  bool _cargando = false;
  bool _guardando = false;

  // Estados seleccionados pero aún no guardados.
  final Map<String, EstadoAsistencia> _pendientes = {};

  @override
  void initState() {
    super.initState();
    _aulaElegida = widget.aulaActual;
  }

  // Mostrar Falta si el estado está sin registrar.
  EstadoAsistencia _estadoVisible(Estudiante estudiante) {
    if (_pendientes.containsKey(estudiante.codigo)) {
      return _pendientes[estudiante.codigo]!;
    }

    if (estudiante.estado == EstadoAsistencia.sinRegistrar) {
      return EstadoAsistencia.falta;
    }

    return estudiante.estado;
  }

  String _nombreEstado(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.presente:
        return 'Presente';
      case EstadoAsistencia.tardanza:
        return 'Tardanza';
      case EstadoAsistencia.falta:
        return 'Falta';
      case EstadoAsistencia.sinRegistrar:
        return 'Sin registrar';
    }
  }

  Color _colorEstado(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.presente:
        return Colors.green.shade700;
      case EstadoAsistencia.tardanza:
        return Colors.orange.shade800;
      case EstadoAsistencia.falta:
        return Colors.red.shade700;
      case EstadoAsistencia.sinRegistrar:
        return Colors.grey;
    }
  }

  // LISTAR ESTUDIANTES DEL AULA
  Future<void> _listar() async {
    if (_pendientes.isNotEmpty && _aulaElegida != widget.aulaActual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guarda primero los cambios pendientes.')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      // La carga asíncrona inicial ya se realizó
      // desde LoginScreen. Aquí solo filtramos.
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      widget.onCambiarAula(_aulaElegida);

      setState(() => _filtro = 'Todos');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al listar: $e')));
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  // CAMBIAR ESTADO TEMPORALMENTE
  void _seleccionarEstado(Estudiante estudiante, EstadoAsistencia nuevo) {
    setState(() {
      final estadoOriginal = estudiante.estado == EstadoAsistencia.sinRegistrar
          ? EstadoAsistencia.falta
          : estudiante.estado;

      if (nuevo == estadoOriginal) {
        _pendientes.remove(estudiante.codigo);
      } else {
        _pendientes[estudiante.codigo] = nuevo;
      }
    });
  }

  // GUARDAR EN ASISTENCIA SERVICE
  void _guardarAsistencia() {
    if (_guardando) return;

    final estudiantes = widget.servicio.obtenerTodos(
      aulaCodigo: widget.aulaActual,
    );

    setState(() => _guardando = true);

    int guardados = 0;
    int errores = 0;

    try {
      for (final estudiante in estudiantes) {
        final tieneCambio = _pendientes.containsKey(estudiante.codigo);

        final sinRegistrar = estudiante.estado == EstadoAsistencia.sinRegistrar;

        // Guardar solo registros nuevos o modificados.
        if (!tieneCambio && !sinRegistrar) {
          continue;
        }

        final nuevoEstado = _estadoVisible(estudiante);

        final correcto = widget.servicio.registrarOModificarAsistencia(
          estudiante.codigo,
          nuevoEstado,
          aulaCodigo: widget.aulaActual,
        );

        if (correcto) {
          guardados++;
          _pendientes.remove(estudiante.codigo);
        } else {
          errores++;
        }
      }

      // Actualizar también el reporte.
      widget.onActualizado();

      if (!mounted) return;

      if (errores == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              guardados > 0
                  ? 'Asistencia guardada: $guardados registros.'
                  : 'No hay cambios pendientes.',
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$guardados registros guardados. '
              '$errores no se pudieron guardar.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final aulas = widget.servicio.obtenerAulas();

    final estudiantes = widget.servicio.obtenerTodos(
      aulaCodigo: widget.aulaActual,
    );

    final visibles = estudiantes.where((estudiante) {
      return _filtro == 'Todos' ||
          _nombreEstado(_estadoVisible(estudiante)) == _filtro;
    }).toList();

    final pendientes = estudiantes.where((estudiante) {
      return estudiante.estado == EstadoAsistencia.sinRegistrar ||
          _pendientes.containsKey(estudiante.codigo);
    }).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Control de asistencia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Selecciona un aula y registra la asistencia.',
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 22),

        // SELECCIÓN DE AULA
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _aulaElegida,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar aula',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                items: aulas.map((aula) {
                  return DropdownMenuItem(
                    value: aula.codigo,
                    child: Text(aula.nombre),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => _aulaElegida = valor);
                  }
                },
              ),
            ),

            const SizedBox(width: 10),

            ElevatedButton.icon(
              onPressed: _cargando ? null : _listar,
              icon: _cargando
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search, size: 18),
              label: const Text('Listar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: dorado,
                foregroundColor: texto,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // CONTADOR Y FILTRO
        Row(
          children: [
            Expanded(
              child: Text(
                'Estudiantes (${estudiantes.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
            ),

            SizedBox(
              width: 155,
              child: DropdownButtonFormField<String>(
                value: _filtro,
                isExpanded: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.filter_list, size: 19, color: morado),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: ['Todos', 'Presente', 'Tardanza', 'Falta'].map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => _filtro = valor);
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // TABLA DE ASISTENCIA
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
                2: FixedColumnWidth(112),
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
                    _celda('Estado', titulo: true),
                  ],
                ),

                ...visibles.map((estudiante) {
                  final estado = _estadoVisible(estudiante);

                  return TableRow(
                    decoration: BoxDecoration(
                      color: _pendientes.containsKey(estudiante.codigo)
                          ? const Color(0xFFFFF9EB)
                          : Colors.white,
                    ),
                    children: [
                      _celda(estudiante.codigo),

                      _celda(
                        '${estudiante.nombre} '
                        '${estudiante.apellido}',
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 10,
                        ),
                        child: DropdownButton<EstadoAsistencia>(
                          value: estado,
                          isExpanded: true,
                          isDense: true,
                          underline: const SizedBox.shrink(),
                          iconSize: 18,
                          style: TextStyle(
                            fontSize: 12,
                            color: _colorEstado(estado),
                          ),
                          items:
                              [
                                EstadoAsistencia.presente,
                                EstadoAsistencia.tardanza,
                                EstadoAsistencia.falta,
                              ].map((opcion) {
                                return DropdownMenuItem(
                                  value: opcion,
                                  child: Text(
                                    _nombreEstado(opcion),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _colorEstado(opcion),
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (nuevo) {
                            if (nuevo != null) {
                              _seleccionarEstado(estudiante, nuevo);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),

        if (visibles.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No se encontraron estudiantes.',
              textAlign: TextAlign.center,
            ),
          ),

        const SizedBox(height: 18),

        if (pendientes > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '$pendientes registro(s) pendiente(s) de guardar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: morado,
              ),
            ),
          ),

        // BOTÓN GUARDAR
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: pendientes == 0 || _guardando
                ? null
                : _guardarAsistencia,
            icon: const Icon(Icons.save_outlined),
            label: Text(_guardando ? 'Guardando...' : 'Guardar asistencia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: dorado,
              foregroundColor: texto,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
