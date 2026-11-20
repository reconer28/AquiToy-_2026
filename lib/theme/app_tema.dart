import 'package:flutter/material.dart';

class AppTheme {
  // 60%: Fondo principal
  static const Color principal = Color(0xFFF3EDFA);

  // 30%: Morado institucional
  static const Color secundario = Color(0xFF60358C);

  // 10%: Color de acento
  static const Color acento = Color(0xFFF5BC51);

  // Colores de apoyo para lectura
  static const Color texto = Color(0xFF352447);
  static const Color blanco = Colors.white;

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: principal,
      colorScheme: ColorScheme.fromSeed(seedColor: secundario),
    );
  }
}
