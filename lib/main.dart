import 'models/estudiante.dart';
import 'services/asistencia_service.dart';

void main() async {
  final servicio = AsistenciaService();

  print('--- CARGANDO 20 ESTUDIANTES (10 POR AULA) ---');
  await servicio.cargarEstudiantes();

  print('\n--- ESTUDIANTES DE AULA-1 ---');
  for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-1')) {
    print(est);
  }

  print('\n--- ESTUDIANTES DE AULA-2 ---');
  for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-2')) {
    print(est);
  }

  // Registrar asistencia en AULA-1
  servicio.registrarOModificarAsistencia('EST001', EstadoAsistencia.presente, aulaCodigo: 'AULA-1');
  servicio.registrarOModificarAsistencia('EST002', EstadoAsistencia.tardanza, aulaCodigo: 'AULA-1');
  servicio.registrarOModificarAsistencia('EST003', EstadoAsistencia.falta, aulaCodigo: 'AULA-1');

  // Registrar asistencia en AULA-2
  servicio.registrarOModificarAsistencia('EST011', EstadoAsistencia.presente, aulaCodigo: 'AULA-2');
  servicio.registrarOModificarAsistencia('EST012', EstadoAsistencia.presente, aulaCodigo: 'AULA-2');
  servicio.registrarOModificarAsistencia('EST013', EstadoAsistencia.falta, aulaCodigo: 'AULA-2');

  // Modificar estado de EST003 en AULA-1
  servicio.registrarOModificarAsistencia('EST003', EstadoAsistencia.presente, aulaCodigo: 'AULA-1');

  print('\n--- RESUMEN AULA-1 ---');
  print(servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-1'));

  print('\n--- RESUMEN AULA-2 ---');
  print(servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-2'));

  print('\n--- FILTRO: FALTAS EN AULA-2 ---');
  for (var est in servicio.filtrarPorEstado(EstadoAsistencia.falta, aulaCodigo: 'AULA-2')) {
    print(est);
  }
}