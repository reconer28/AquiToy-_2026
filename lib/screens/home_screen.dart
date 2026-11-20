import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'asistencia_screen.dart';
import 'reporte_screen.dart';
import 'micuenta_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pagina = 0;
  String _aulaActual = '1.º A';
  String _nombreDocente = 'Docente AquiToy';

  // Datos de ejemplo para el frontend.
  final List<Map<String, String>> _estudiantes = [
    {
      'codigo': 'A001',
      'nombre': 'Ana Torres Pérez',
      'aula': '1.º A',
      'estado': 'Presente',
    },
    {
      'codigo': 'A002',
      'nombre': 'Luis Pérez Díaz',
      'aula': '1.º A',
      'estado': 'Tardanza',
    },
    {
      'codigo': 'A003',
      'nombre': 'Rosa Díaz López',
      'aula': '1.º A',
      'estado': 'Falta',
    },
    {
      'codigo': 'A004',
      'nombre': 'José Flores Ruiz',
      'aula': '1.º A',
      'estado': 'Presente',
    },
    {
      'codigo': 'A005',
      'nombre': 'María García Soto',
      'aula': '1.º A',
      'estado': 'Presente',
    },
    {
      'codigo': 'A006',
      'nombre': 'Carlos Rojas Vega',
      'aula': '1.º A',
      'estado': 'Presente',
    },
    {
      'codigo': 'A007',
      'nombre': 'Lucía Ramos Castro',
      'aula': '1.º A',
      'estado': 'Tardanza',
    },
    {
      'codigo': 'A008',
      'nombre': 'Pedro Mendoza León',
      'aula': '1.º A',
      'estado': 'Presente',
    },
    {
      'codigo': 'A009',
      'nombre': 'Elena Vargas Silva',
      'aula': '1.º A',
      'estado': 'Falta',
    },
    {
      'codigo': 'A010',
      'nombre': 'Diego Chávez Ríos',
      'aula': '1.º A',
      'estado': 'Presente',
    },

    {
      'codigo': 'B001',
      'nombre': 'Sofía Herrera Ruiz',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B002',
      'nombre': 'Miguel Salas Pérez',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B003',
      'nombre': 'Andrea Campos Díaz',
      'aula': '1.º B',
      'estado': 'Tardanza',
    },
    {
      'codigo': 'B004',
      'nombre': 'Jorge Medina Soto',
      'aula': '1.º B',
      'estado': 'Falta',
    },
    {
      'codigo': 'B005',
      'nombre': 'Paola Ríos Torres',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B006',
      'nombre': 'Mario López Vargas',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B007',
      'nombre': 'Karla Paredes León',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B008',
      'nombre': 'Raúl Castillo Flores',
      'aula': '1.º B',
      'estado': 'Falta',
    },
    {
      'codigo': 'B009',
      'nombre': 'Diana Molina Ramos',
      'aula': '1.º B',
      'estado': 'Presente',
    },
    {
      'codigo': 'B010',
      'nombre': 'Hugo Sánchez Castro',
      'aula': '1.º B',
      'estado': 'Tardanza',
    },
  ];

  void _cambiarEstado(String codigo, String estado) {
    setState(() {
      final estudiante = _estudiantes.firstWhere(
        (item) => item['codigo'] == codigo,
      );
      estudiante['estado'] = estado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.secundario,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppTheme.acento, size: 25),
            SizedBox(width: 10),
            Text(
              'AquiToy!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: _pagina,
        children: [
          AsistenciaScreen(
            estudiantes: _estudiantes,
            aulaActual: _aulaActual,
            onCambiarAula: (aula) {
              setState(() => _aulaActual = aula);
            },
            onCambiarEstado: _cambiarEstado,
          ),
          ReporteScreen(estudiantes: _estudiantes, aulaActual: _aulaActual),
          MiCuentaScreen(
            nombreDocente: _nombreDocente,
            onCambiarNombre: (nombre) {
              setState(() => _nombreDocente = nombre);
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pagina,
        selectedItemColor: AppTheme.secundario,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (indice) {
          setState(() => _pagina = indice);
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
