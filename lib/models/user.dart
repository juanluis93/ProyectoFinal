class User {
  final String id;
  final String cedula;
  final String nombre;
  final String password;
  final String apellido;
  final String email;
  final String telefono;
  final String? token;

  User({
    required this.id,
    required this.cedula,
    required this.nombre,
    required this.password,
    required this.apellido,
    required this.email,
    required this.telefono,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula': cedula,
      'nombre': nombre,
      'password': password,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'token': token,
    };
  }

  String get fullName => '$nombre $apellido';
}
