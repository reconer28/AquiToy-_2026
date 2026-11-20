class Docente {
  final String codigo;
  final String nombre;
  final String apellido;
  final String correo;
  final String aulaCodigo;

  const Docente({
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.aulaCodigo,
  });

  // Lista estática de 3 docentes en su propio archivo
  static const List<Docente> listaEstatica = [
    Docente(
      codigo: 'DOC001',
      nombre: 'Ricardo',
      apellido: 'Salazar',
      correo: 'ricardo.salazar@instituto.edu.pe',
      aulaCodigo: 'AULA-1',
    ),
    Docente(
      codigo: 'DOC002',
      nombre: 'Patricia',
      apellido: 'Mendoza',
      correo: 'patricia.mendoza@instituto.edu.pe',
      aulaCodigo: 'AULA-2',
    ),
    Docente(
      codigo: 'DOC003',
      nombre: 'Fernando',
      apellido: 'Chávez',
      correo: 'fernando.chavez@instituto.edu.pe',
      aulaCodigo: 'AULA-1',
    ),
  ];

  @override
  String toString() {
    return '[$codigo] $nombre $apellido ($correo) - Aula: $aulaCodigo';
  }
}
