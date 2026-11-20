import 'package:flutter/material.dart';

import 'models/estudiante.dart';
import 'services/asistencia_service.dart';

import 'screens/login_screen.dart';
import 'theme/app_tema.dart';

// PUNTO DE ENTRADA DE LA APLICACIÓN
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Iniciar la interfaz gráfica.
  runApp(const AquiToyApp());

  // Ejecutar las pruebas del servicio sin detener la interfaz.
  await probarServicioAsistencia();
}

// APLICACIÓN FLUTTER
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

// PRUEBAS DEL SERVICIO DE ASISTENCIA
Future<void> probarServicioAsistencia() async {
  try {
    final servicio = AsistenciaService();

    debugPrint('--- CARGANDO 20 ESTUDIANTES (10 POR AULA) ---');

    // Cargar estudiantes de forma asíncrona.
    await servicio.cargarEstudiantes();

    // LISTAR ESTUDIANTES DEL AULA 1
    debugPrint('\n--- ESTUDIANTES DE AULA-1 ---');

    for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-1')) {
      debugPrint('$est');
    }

    // LISTAR ESTUDIANTES DEL AULA 2
    debugPrint('\n--- ESTUDIANTES DE AULA-2 ---');

    for (var est in servicio.obtenerTodos(aulaCodigo: 'AULA-2')) {
      debugPrint('$est');
    }

    // REGISTRAR ASISTENCIA EN AULA 1
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

    // REGISTRAR ASISTENCIA EN AULA 2
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

    // MODIFICAR ASISTENCIA EN AULA 1
    servicio.registrarOModificarAsistencia(
      'EST003',
      EstadoAsistencia.presente,
      aulaCodigo: 'AULA-1',
    );

    // RESUMEN ESTADÍSTICO DEL AULA 1
    debugPrint('\n--- RESUMEN AULA-1 ---');

    debugPrint('${servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-1')}');

    // RESUMEN ESTADÍSTICO DEL AULA 2
    debugPrint('\n--- RESUMEN AULA-2 ---');

    debugPrint('${servicio.obtenerResumenEstadistico(aulaCodigo: 'AULA-2')}');

    // FILTRAR ESTUDIANTES CON FALTA EN AULA 2
    debugPrint('\n--- FILTRO: FALTAS EN AULA-2 ---');

    for (var est in servicio.filtrarPorEstado(
      EstadoAsistencia.falta,
      aulaCodigo: 'AULA-2',
    )) {
      debugPrint('$est');
    }

    debugPrint('\n--- PRUEBAS FINALIZADAS ---');
  } catch (e, stackTrace) {
    debugPrint('ERROR EN EL SERVICIO DE ASISTENCIA: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}
