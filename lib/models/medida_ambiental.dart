class MedidaAmbiental {
  final int id;
  final String titulo;
  final String descripcion;
  final String? imagen;
  final String categoria;
  final String? consejos;

  MedidaAmbiental({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.imagen,
    required this.categoria,
    this.consejos,
  });

  factory MedidaAmbiental.fromJson(Map<String, dynamic> json) {
    return MedidaAmbiental(
      id: json['id'] ?? 0,
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      imagen: json['imagen']?.toString(),
      categoria: json['categoria']?.toString() ?? '',
      consejos: json['consejos']?.toString(),
    );
  }
}
