class Voluntario {
  final int? id;
  final String cedula;
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String telefono;
  final String? direccion;
  final String? areaInteres;
  final String? disponibilidad;
  final String? motivacion;
  final DateTime? fechaRegistro;
  final String? estado;

  Voluntario({
    this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    required this.telefono,
    this.direccion,
    this.areaInteres,
    this.disponibilidad,
    this.motivacion,
    this.fechaRegistro,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cedula': cedula,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password,
      'telefono': telefono,
      if (direccion != null) 'direccion': direccion,
      if (areaInteres != null) 'area_interes': areaInteres,
      if (disponibilidad != null) 'disponibilidad': disponibilidad,
      if (motivacion != null) 'motivacion': motivacion,
      if (fechaRegistro != null)
        'fecha_registro': fechaRegistro!.toIso8601String(),
      if (estado != null) 'estado': estado,
    };
  }

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      id: json['id'],
      cedula: json['cedula']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      direccion: json['direccion']?.toString(),
      areaInteres: json['area_interes']?.toString(),
      disponibilidad: json['disponibilidad']?.toString(),
      motivacion: json['motivacion']?.toString(),
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'])
          : null,
      estado: json['estado']?.toString(),
    );
  }
}
