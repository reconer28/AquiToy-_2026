import '../models/docente.dart';
import '../models/estudiante.dart';

class AsistenciaService {
  List<Estudiante> _estudiantes = [];

  List<Aula> obtenerAulas() => Aula.aulasEstaticas;

  List<Docente> obtenerDocentes() => Docente.listaEstatica;

  Docente? buscarDocentePorCorreo(String correo) {
    try {
      return Docente.listaEstatica.firstWhere(
        (d) => d.correo.toLowerCase() == correo.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // Carga asíncrona desde la lista estática con try-catch
  Future<List<Estudiante>> cargarEstudiantes({
    String? aulaCodigo,
    bool simularError = false,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (simularError) {
        throw Exception('Error de conexión al cargar estudiantes.');
      }

      final origen = aulaCodigo == null
          ? Estudiante.listaEstatica
          : Estudiante.listaEstatica.where((e) => e.aulaCodigo == aulaCodigo);

      _estudiantes = origen
          .map(
            (e) => Estudiante(
              codigo: e.codigo,
              nombre: e.nombre,
              apellido: e.apellido,
              aulaCodigo: e.aulaCodigo,
              estado: e.estado,
            ),
          )
          .toList();

      return _estudiantes;
    } catch (e) {
      print('Error en cargarEstudiantes: $e');
      rethrow;
    }
  }

  List<Estudiante> obtenerTodos({String? aulaCodigo}) {
    if (aulaCodigo == null) return _estudiantes;
    return _estudiantes.where((e) => e.aulaCodigo == aulaCodigo).toList();
  }

  // Registrar o modificar estado de asistencia con try-catch
  bool registrarOModificarAsistencia(
    String codigo,
    EstadoAsistencia nuevoEstado, {
    String? aulaCodigo,
  }) {
    try {
      if (nuevoEstado == EstadoAsistencia.sinRegistrar) {
        throw ArgumentError('Debe asignar Presente, Tardanza o Falta.');
      }

      final index = _estudiantes.indexWhere(
        (e) => e.codigo == codigo && (aulaCodigo == null || e.aulaCodigo == aulaCodigo),
      );

      if (index == -1) {
        throw StateError(
          'Estudiante $codigo no encontrado${aulaCodigo != null ? " en $aulaCodigo" : ""}.',
        );
      }

      _estudiantes[index].estado = nuevoEstado;
      return true;
    } catch (e) {
      print('Error al registrar/modificar asistencia: $e');
      return false;
    }
  }

  int contarPorEstado(EstadoAsistencia estado, {String? aulaCodigo}) {
    return obtenerTodos(aulaCodigo: aulaCodigo).where((e) => e.estado == estado).length;
  }

  int totalPresentes({String? aulaCodigo}) =>
      contarPorEstado(EstadoAsistencia.presente, aulaCodigo: aulaCodigo);

  int totalTardanzas({String? aulaCodigo}) =>
      contarPorEstado(EstadoAsistencia.tardanza, aulaCodigo: aulaCodigo);

  int totalFaltas({String? aulaCodigo}) =>
      contarPorEstado(EstadoAsistencia.falta, aulaCodigo: aulaCodigo);

  double calcularPorcentajeAsistencia({String? aulaCodigo}) {
    try {
      final lista = obtenerTodos(aulaCodigo: aulaCodigo);
      if (lista.isEmpty) return 0.0;

      final asistieron = totalPresentes(aulaCodigo: aulaCodigo) +
          totalTardanzas(aulaCodigo: aulaCodigo);
      final porcentaje = (asistieron / lista.length) * 100;
      return double.parse(porcentaje.toStringAsFixed(2));
    } catch (e) {
      print('Error al calcular porcentaje: $e');
      return 0.0;
    }
  }

  List<Estudiante> filtrarPorEstado(EstadoAsistencia estado, {String? aulaCodigo}) {
    return obtenerTodos(aulaCodigo: aulaCodigo)
        .where((e) => e.estado == estado)
        .toList();
  }

  Map<String, dynamic> obtenerResumenEstadistico({String? aulaCodigo}) {
    final lista = obtenerTodos(aulaCodigo: aulaCodigo);
    return {
      'aula': aulaCodigo ?? 'TODAS',
      'totalEstudiantes': lista.length,
      'presentes': totalPresentes(aulaCodigo: aulaCodigo),
      'tardanzas': totalTardanzas(aulaCodigo: aulaCodigo),
      'faltas': totalFaltas(aulaCodigo: aulaCodigo),
      'sinRegistrar': contarPorEstado(EstadoAsistencia.sinRegistrar, aulaCodigo: aulaCodigo),
      'porcentajeAsistencia': '${calcularPorcentajeAsistencia(aulaCodigo: aulaCodigo)}%',
    };
  }
}