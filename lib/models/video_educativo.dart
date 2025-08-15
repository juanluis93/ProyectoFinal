class VideoEducativo {
  final String id;
  final String titulo;
  final String descripcion;
  final String url;
  final String? thumbnail;
  final String categoria;
  final String? duracion;
  final String? fechaCreacion;

  VideoEducativo({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.url,
    this.thumbnail,
    required this.categoria,
    this.duracion,
    this.fechaCreacion,
  });

  factory VideoEducativo.fromJson(Map<String, dynamic> json) {
    return VideoEducativo(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      categoria: json['categoria']?.toString() ?? '',
      duracion: json['duracion']?.toString(),
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  // Para compatibilidad con el código existente
  DateTime get fechaPublicacion {
    try {
      return fechaCreacion != null
          ? DateTime.parse(fechaCreacion!)
          : DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
}
