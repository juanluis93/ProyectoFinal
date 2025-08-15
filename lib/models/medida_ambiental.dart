class MedidaAmbiental {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? icono;
  final String? fechaCreacion;

  MedidaAmbiental({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.icono,
    this.fechaCreacion,
  });

  factory MedidaAmbiental.fromJson(Map<String, dynamic> json) {
    return MedidaAmbiental(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      icono: json['icono']?.toString(),
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  // Para compatibilidad con el código existente
  String? get imagen => null;
  String? get consejos => null;
}
