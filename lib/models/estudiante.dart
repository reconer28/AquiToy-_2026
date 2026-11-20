enum EstadoAsistencia {
  sinRegistrar,
  presente,
  tardanza,
  falta,
}

class Aula {
  final String codigo;
  final String nombre;

  const Aula({
    required this.codigo,
    required this.nombre,
  });

  static const List<Aula> aulasEstaticas = [
    Aula(codigo: 'AULA-1', nombre: 'Aula 1'),
    Aula(codigo: 'AULA-2', nombre: 'Aula 2'),
  ];
}

class Estudiante {
  final String codigo;
  final String nombre;
  final String apellido;
  final String aulaCodigo;
  EstadoAsistencia estado;

  Estudiante({
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.aulaCodigo,
    this.estado = EstadoAsistencia.sinRegistrar,
  });

  // Lista estática: 10 estudiantes en AULA-1 y 10 estudiantes en AULA-2
  static List<Estudiante> listaEstatica = [
    // --- AULA-1 (10 estudiantes) ---
    Estudiante(codigo: 'EST001', nombre: 'Ana', apellido: 'Gómez', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST002', nombre: 'Luis', apellido: 'Torres', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST003', nombre: 'Carlos', apellido: 'Mendoza', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST004', nombre: 'María', apellido: 'Rojas', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST005', nombre: 'José', apellido: 'Vargas', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST006', nombre: 'Lucía', apellido: 'Sánchez', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST007', nombre: 'Diego', apellido: 'Flores', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST008', nombre: 'Valeria', apellido: 'Ramírez', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST009', nombre: 'Jorge', apellido: 'Herrera', aulaCodigo: 'AULA-1'),
    Estudiante(codigo: 'EST010', nombre: 'Camila', apellido: 'Morales', aulaCodigo: 'AULA-1'),

    // --- AULA-2 (10 estudiantes) ---
    Estudiante(codigo: 'EST011', nombre: 'Pedro', apellido: 'Castillo', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST012', nombre: 'Sofía', apellido: 'Paredes', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST013', nombre: 'Andrés', apellido: 'Quispe', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST014', nombre: 'Elena', apellido: 'Huamán', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST015', nombre: 'Mateo', apellido: 'Salazar', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST016', nombre: 'Isabella', apellido: 'Medina', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST017', nombre: 'Sebastián', apellido: 'Guerrero', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST018', nombre: 'Natalia', apellido: 'Cárdenas', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST019', nombre: 'Gabriel', apellido: 'Delgado', aulaCodigo: 'AULA-2'),
    Estudiante(codigo: 'EST020', nombre: 'Daniela', apellido: 'Silva', aulaCodigo: 'AULA-2'),
  ];

  @override
  String toString() {
    return '[$aulaCodigo] [$codigo] $nombre $apellido - Estado: ${estado.name.toUpperCase()}';
  }
}