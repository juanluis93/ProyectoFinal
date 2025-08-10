class AreaProtegida {
  final int id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final double latitud;
  final double longitud;
  final String? imagen;
  final String? ubicacion;
  final String? telefono;
  final String? horario;

  AreaProtegida({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.latitud,
    required this.longitud,
    this.imagen,
    this.ubicacion,
    this.telefono,
    this.horario,
  });

  factory AreaProtegida.fromJson(Map<String, dynamic> json) {
    return AreaProtegida(
      id: json['id'] ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      latitud: double.tryParse(json['latitud']?.toString() ?? '0') ?? 0.0,
      longitud: double.tryParse(json['longitud']?.toString() ?? '0') ?? 0.0,
      imagen: json['imagen']?.toString(),
      ubicacion: json['ubicacion']?.toString(),
      telefono: json['telefono']?.toString(),
      horario: json['horario']?.toString(),
    );
  }
}
