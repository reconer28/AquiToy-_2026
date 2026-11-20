import 'models/estudiante.dart';
import 'services/asistencia_service.dart';

void main() async {
  final servicio = AsistenciaService();

  print('--- DOCENTES ---');
  for (var doc in servicio.obtenerDocentes()) {
    print(doc);
  }

  print('\n--- CARGANDO ESTUDIANTES (20 TOTAL: 10 POR AULA) ---');
  await servicio.cargarEstudiantes();

  print('\n--- AULA-1 ---');
  for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-1')) {
    print(est);
  }

  print('\n--- AULA-2 ---');
  for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-2')) {
    print(est);
  }

  // Registrar asistencia en AULA-1
  servicio.registrarOModificarAsistencia('EST001', EstadoAsistencia.presente, aulaCodigo: 'AULA-1');
  servicio.registrarOModificarAsistencia('EST002', EstadoAsistencia.tardanza, aulaCodigo: 'AULA-1');
  servicio.registrarOModificarAsistencia('EST003', EstadoAsistencia.falta, aulaCodigo: 'AULA-1');

  // Modificar estado en AULA-1
  servicio.registrarOModificarAsistencia('EST003', EstadoAsistencia.presente, aulaCodigo: 'AULA-1');

  // Registrar asistencia en AULA-2
  servicio.registrarOModificarAsistencia('EST011', EstadoAsistencia.presente, aulaCodigo: 'AULA-2');
  servicio.registrarOModificarAsistencia('EST012', EstadoAsistencia.falta, aulaCodigo: 'AULA-2');

  // Prueba de error controlado
  servicio.registrarOModificarAsistencia('EST999', EstadoAsistencia.presente);

  print('\n--- RESUMEN AULA-1 ---');
  print(servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-1'));

  print('\n--- RESUMEN AULA-2 ---');
  print(servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-2'));

  print('\n--- FILTRO: FALTAS EN AULA-2 ---');
  for (var est in servicio.filtrarPorEstado(EstadoAsistencia.falta, aulaCodigo: 'AULA-2')) {
    print(est);
  }
}