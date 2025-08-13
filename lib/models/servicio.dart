class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final String? imagen;
  final String? url;
  final bool activo;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.imagen,
    this.url,
    required this.activo,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      imagen: json['imagen']?.toString(),
      url: json['url']?.toString(),
      activo: json['activo'] == 1 || json['activo'] == true,
    );
  }
}
