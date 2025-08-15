class Reporte {
  final String? id;
  final String? codigo;
  final String titulo;
  final String descripcion;
  final String? foto;
  final double latitud;
  final double longitud;
  final String estado;
  final String? comentarioMinisterio;
  final String fecha;

  Reporte({
    this.id,
    this.codigo,
    required this.titulo,
    required this.descripcion,
    this.foto,
    required this.latitud,
    required this.longitud,
    this.estado = 'pendiente',
    this.comentarioMinisterio,
    required this.fecha,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id']?.toString(),
      codigo: json['codigo']?.toString(),
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      foto: json['foto']?.toString(),
      latitud: double.tryParse(json['latitud']?.toString() ?? '0') ?? 0.0,
      longitud: double.tryParse(json['longitud']?.toString() ?? '0') ?? 0.0,
      estado: json['estado']?.toString() ?? 'pendiente',
      comentarioMinisterio: json['comentario_ministerio']?.toString(),
      fecha: json['fecha']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      if (codigo != null && codigo!.isNotEmpty) 'codigo': codigo,
      'titulo': titulo,
      'descripcion': descripcion,
      'foto': foto ?? '', // Enviar string vacío si no hay foto
      'latitud': latitud,
      'longitud': longitud,
      'estado': estado,
      if (comentarioMinisterio != null && comentarioMinisterio!.isNotEmpty)
        'comentario_ministerio': comentarioMinisterio,
      'fecha': fecha,
    };
  }

  // Estados válidos según la API
  static const List<String> estadosValidos = [
    'pendiente',
    'en_proceso',
    'resuelto',
    'rechazado',
  ];
}
