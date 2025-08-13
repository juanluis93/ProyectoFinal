class Noticia {
  final int id;
  final String titulo;
  final String contenido;
  final String? imagen;
  final String fecha;
  final String? autor;

  Noticia({
    required this.id,
    required this.titulo,
    required this.contenido,
    this.imagen,
    required this.fecha,
    this.autor,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      contenido: json['contenido']?.toString() ?? '',
      imagen: json['imagen']?.toString(),
      fecha: json['fecha']?.toString() ?? '',
      autor: json['autor']?.toString(),
    );
  }
}
