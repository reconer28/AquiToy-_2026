import 'package:flutter/material.dart';

// MODELOS Y SERVICIOS
import 'models/estudiante.dart';
import 'services/asistencia_service.dart';

// FRONTEND
import 'screens/login_screen.dart';
import 'theme/app_tema.dart';

// ==========================================
// 1. INICIO DE LA APLICACIÓN
// ==========================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Iniciar la aplicación Flutter.
  runApp(const AquiToyApp());

  // Ejecutar pruebas del servicio.
  await probarServicioAsistencia();
}

// ==========================================
// 2. CONFIGURACIÓN DE FLUTTER
// ==========================================

class AquiToyApp extends StatelessWidget {
  const AquiToyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquiToy!',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 3. PRUEBAS DEL SERVICIO DE ASISTENCIA
// ==========================================

Future<void> probarServicioAsistencia() async {
  try {
    final servicio = AsistenciaService();

    // --------------------------------------
    // MOSTRAR DOCENTES
    // --------------------------------------

    debugPrint('\n--- DOCENTES ---');

    for (var doc in servicio.obtenerDocentes()) {
      debugPrint('$doc');
    }

    // --------------------------------------
    // CARGAR ESTUDIANTES
    // --------------------------------------

    debugPrint(
      '\n--- CARGANDO ESTUDIANTES '
      '(20 TOTAL: 10 POR AULA) ---',
    );

    await servicio.cargarEstudiantes();

    // --------------------------------------
    // LISTAR ESTUDIANTES DEL AULA 1
    // --------------------------------------

    debugPrint('\n--- AULA-1 ---');

    for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-1')) {
      debugPrint('$est');
    }

    // --------------------------------------
    // LISTAR ESTUDIANTES DEL AULA 2
    // --------------------------------------

    debugPrint('\n--- AULA-2 ---');

    for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-2')) {
      debugPrint('$est');
    }

    // --------------------------------------
    // REGISTRAR ASISTENCIA EN AULA 1
    // --------------------------------------

    debugPrint('\n--- REGISTRANDO AULA-1 ---');

    servicio.registrarOModificarAsistencia(
      'EST001',
      EstadoAsistencia.presente,
      aulaCodigo: 'AULA-1',
    );

    servicio.registrarOModificarAsistencia(
      'EST002',
      EstadoAsistencia.tardanza,
      aulaCodigo: 'AULA-1',
    );

    servicio.registrarOModificarAsistencia(
      'EST003',
      EstadoAsistencia.falta,
      aulaCodigo: 'AULA-1',
    );

    // --------------------------------------
    // MODIFICAR ASISTENCIA EN AULA 1
    // --------------------------------------

    debugPrint('\n--- MODIFICANDO EST003 ---');

    servicio.registrarOModificarAsistencia(
      'EST003',
      EstadoAsistencia.presente,
      aulaCodigo: 'AULA-1',
    );

    // --------------------------------------
    // REGISTRAR ASISTENCIA EN AULA 2
    // --------------------------------------

    debugPrint('\n--- REGISTRANDO AULA-2 ---');

    servicio.registrarOModificarAsistencia(
      'EST011',
      EstadoAsistencia.presente,
      aulaCodigo: 'AULA-2',
    );

    servicio.registrarOModificarAsistencia(
      'EST012',
      EstadoAsistencia.presente,
      aulaCodigo: 'AULA-2',
    );

    servicio.registrarOModificarAsistencia(
      'EST013',
      EstadoAsistencia.falta,
      aulaCodigo: 'AULA-2',
    );

    // Modificar EST012 de Presente a Falta.
    servicio.registrarOModificarAsistencia(
      'EST012',
      EstadoAsistencia.falta,
      aulaCodigo: 'AULA-2',
    );

    // --------------------------------------
    // PRUEBA DE ERROR CONTROLADO
    // --------------------------------------

    debugPrint('\n--- PRUEBA DE ERROR EST999 ---');

    try {
      servicio.registrarOModificarAsistencia(
        'EST999',
        EstadoAsistencia.presente,
      );

      debugPrint(
        'Prueba EST999 ejecutada. '
        'Revisar el resultado del servicio.',
      );
    } catch (e) {
      debugPrint('Excepción controlada para EST999: $e');
    }

    // --------------------------------------
    // RESUMEN ESTADÍSTICO AULA 1
    // --------------------------------------

    debugPrint('\n--- RESUMEN AULA-1 ---');

    final resumenAula1 = servicio.obtenerResumenEstadistico(
      aulaCodigo: 'AULA-1',
    );

    debugPrint('$resumenAula1');

    // --------------------------------------
    // RESUMEN ESTADÍSTICO AULA 2
    // --------------------------------------

    debugPrint('\n--- RESUMEN AULA-2 ---');

    final resumenAula2 = servicio.obtenerResumenEstadistico(
      aulaCodigo: 'AULA-2',
    );

    debugPrint('$resumenAula2');

    // --------------------------------------
    // FILTRAR FALTAS EN AULA 2
    // --------------------------------------

    debugPrint('\n--- FILTRO: FALTAS EN AULA-2 ---');

    for (var est in servicio.filtrarPorEstado(
      EstadoAsistencia.falta,
      aulaCodigo: 'AULA-2',
    )) {
      debugPrint('$est');
    }

    // --------------------------------------
    // FINALIZAR PRUEBAS
    // --------------------------------------

    debugPrint('\n--- PRUEBAS FINALIZADAS ---');
  } catch (e, stackTrace) {
    debugPrint('ERROR EN EL SERVICIO DE ASISTENCIA: $e');

    debugPrintStack(stackTrace: stackTrace);
  }
}
