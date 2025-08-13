class Personal {
  final int id;
  final String nombre;
  final String apellido;
  final String cargo;
  final String? foto;
  final String? email;
  final String? telefono;
  final String? departamento;

  Personal({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cargo,
    this.foto,
    this.email,
    this.telefono,
    this.departamento,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      id: json['id'] ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      cargo: json['cargo']?.toString() ?? '',
      foto: json['foto']?.toString(),
      email: json['email']?.toString(),
      telefono: json['telefono']?.toString(),
      departamento: json['departamento']?.toString(),
    );
  }

  String get fullName => '$nombre $apellido';
}
