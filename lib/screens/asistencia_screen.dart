import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

class AsistenciaScreen extends StatefulWidget {
  final List<Map<String, String>> estudiantes;
  final String aulaActual;
  final ValueChanged<String> onCambiarAula;
  final void Function(String, String) onCambiarEstado;

  const AsistenciaScreen({
    super.key,
    required this.estudiantes,
    required this.aulaActual,
    required this.onCambiarAula,
    required this.onCambiarEstado,
  });

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  String _aulaElegida = '1.º A';
  String _filtro = 'Todos';
  bool _cargando = false;

  final List<String> _aulas = ['1.º A', '1.º B'];
  final List<String> _estados = ['Presente', 'Tardanza', 'Falta'];

  // Simulación de carga de estudiantes.
  Future<void> _listar() async {
    setState(() => _cargando = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      widget.onCambiarAula(_aulaElegida);
      setState(() => _filtro = 'Todos');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar estudiantes: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final alumnos = widget.estudiantes
        .where((e) => e['aula'] == widget.aulaActual)
        .toList();

    final visibles = alumnos.where((e) {
      return _filtro == 'Todos' || e['estado'] == _filtro;
    }).toList();

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
          'Control de asistencia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.texto,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Selecciona un aula para consultar y registrar la asistencia.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),

        // SELECTOR DE AULA Y BOTÓN LISTAR
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _aulaElegida,
                decoration: InputDecoration(
                  labelText: 'Seleccionar aula',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _aulas.map((aula) {
                  return DropdownMenuItem(value: aula, child: Text(aula));
                }).toList(),
                onChanged: _cargando
                    ? null
                    : (valor) {
                        if (valor != null) {
                          setState(() => _aulaElegida = valor);
                        }
                      },
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _cargando ? null : _listar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.acento,
                foregroundColor: AppTheme.texto,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 18,
                ),
              ),
              icon: _cargando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: const Text('Listar'),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // FILTRO DE ESTADO
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 10,
          children: [
            Text(
              'Estudiantes (${alumnos.length})',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.texto,
              ),
            ),
            SizedBox(
              width: 190,
              child: DropdownButtonFormField<String>(
                value: _filtro,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.filter_list,
                    color: AppTheme.secundario,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Todos', ..._estados].map((estado) {
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

        const SizedBox(height: 12),

        const Text(
          'Desliza la tabla horizontalmente si necesitas ver más columnas.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 8),

        // TABLA DE ESTUDIANTES
        Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFE9DDF4)),
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Nombre completo')),
                DataColumn(label: Text('Porcentaje')),
                DataColumn(label: Text('Estado')),
              ],
              rows: visibles.map((estudiante) {
                final estado = estudiante['estado']!;

                final asistencia = estado == 'Falta' ? '0%' : '100%';

                return DataRow(
                  cells: [
                    DataCell(Text(estudiante['codigo']!)),
                    DataCell(
                      SizedBox(width: 160, child: Text(estudiante['nombre']!)),
                    ),
                    DataCell(Text(asistencia)),
                    DataCell(
                      DropdownButton<String>(
                        value: estado,
                        underline: const SizedBox.shrink(),
                        items: _estados.map((opcion) {
                          return DropdownMenuItem(
                            value: opcion,
                            child: Text(
                              opcion,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (nuevo) {
                          if (nuevo != null) {
                            widget.onCambiarEstado(
                              estudiante['codigo']!,
                              nuevo,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        if (visibles.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No hay estudiantes con este estado.',
              textAlign: TextAlign.center,
            ),
          ),

        // TOTALES DE LA TABLA
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFE9DDF4),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total del aula: ${alumnos.length} estudiantes',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.texto,
                ),
              ),
              const SizedBox(height: 5),
              Text('Mostrando: ${visibles.length}'),
              const SizedBox(height: 5),
              Text(
                '$presentes presentes  ·  '
                '$tardanzas tardanzas  ·  '
                '$faltas faltas',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // PORCENTAJE GENERAL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Porcentaje de asistencia',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${porcentaje.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.secundario,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: porcentaje / 100,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: const Color(0xFFE2D6EB),
          color: AppTheme.secundario,
        ),
      ],
    );
  }
}
