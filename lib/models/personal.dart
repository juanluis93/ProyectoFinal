class Personal {
  final String id;
  final String nombre;
  final String cargo;
  final String? departamento;
  final String? foto;
  final String? biografia;
  final int? orden;
  final String? fechaCreacion;

  Personal({
    required this.id,
    required this.nombre,
    required this.cargo,
    this.departamento,
    this.foto,
    this.biografia,
    this.orden,
    this.fechaCreacion,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      cargo: json['cargo']?.toString() ?? '',
      departamento: json['departamento']?.toString(),
      foto: json['foto']?.toString(),
      biografia: json['biografia']?.toString(),
      orden: json['orden'] != null
          ? int.tryParse(json['orden'].toString())
          : null,
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  String get fullName => nombre;

  // Para compatibilidad con el código existente
  String? get email => null;
  String? get telefono => null;
}
