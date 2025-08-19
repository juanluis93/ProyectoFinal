
class AreaProtegida {
  final String id;
  final String nombre;
  final String descripcion;
  final String tipo;
  final double latitud;
  final double longitud;
  final String? imagen;
  final String? ubicacion;
  final String? superficie;
  final String? fechaCreacion;

  AreaProtegida({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.latitud,
    required this.longitud,
    this.imagen,
    this.ubicacion,
    this.superficie,
    this.fechaCreacion,
  });

  factory AreaProtegida.fromJson(Map<String, dynamic> json) {
    return AreaProtegida(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      latitud: double.tryParse(json['latitud']?.toString() ?? '0') ?? 0.0,
      longitud: double.tryParse(json['longitud']?.toString() ?? '0') ?? 0.0,
      imagen: json['imagen']?.toString(),
      ubicacion: json['ubicacion']?.toString(),
      superficie: json['superficie']?.toString(),
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }
}
