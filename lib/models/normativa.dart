class Normativa {
  final int id;
  final String titulo;
  final String descripcion;
  final String? documento;
  final String fecha;
  final String categoria;
  final String estado;

  Normativa({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.documento,
    required this.fecha,
    required this.categoria,
    required this.estado,
  });

  factory Normativa.fromJson(Map<String, dynamic> json) {
    return Normativa(
      id: json['id'] ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      documento: json['documento']?.toString(),
      fecha: json['fecha']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
    );
  }
}
