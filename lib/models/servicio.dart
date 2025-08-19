class Servicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String? icono;
  final String? fechaCreacion;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.icono,
    this.fechaCreacion,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      icono: json['icono']?.toString(),
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  // Para compatibilidad con el código existente
  String? get imagen => null;
  String? get url => null;
  bool get activo => true;
}
