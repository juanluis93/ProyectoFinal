class Noticia {
  final String id;
  final String titulo;
  final String? resumen;
  final String contenido;
  final String? imagen;
  final String fecha;
  final String? fechaCreacion;

  Noticia({
    required this.id,
    required this.titulo,
    this.resumen,
    required this.contenido,
    this.imagen,
    required this.fecha,
    this.fechaCreacion,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      resumen: json['resumen']?.toString(),
      contenido: json['contenido']?.toString() ?? '',
      imagen: json['imagen']?.toString(),
      fecha: json['fecha']?.toString() ?? '',
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  // Para compatibilidad con el código existente
  String? get autor => null;
}
