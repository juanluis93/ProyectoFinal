class VideoEducativo {
  final int id;
  final String titulo;
  final String descripcion;
  final String url;
  final String? thumbnail;
  final String categoria;
  final int duracion;
  final DateTime fechaPublicacion;

  VideoEducativo({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.url,
    this.thumbnail,
    required this.categoria,
    required this.duracion,
    required this.fechaPublicacion,
  });

  factory VideoEducativo.fromJson(Map<String, dynamic> json) {
    return VideoEducativo(
      id: json['id'] ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      categoria: json['categoria']?.toString() ?? '',
      duracion: json['duracion'] ?? 0,
      fechaPublicacion: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'])
          : DateTime.now(),
    );
  }
}
