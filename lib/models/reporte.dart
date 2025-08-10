class Reporte {
  final int? id;
  final String titulo;
  final String descripcion;
  final String? foto;
  final double latitud;
  final double longitud;
  final String fecha;
  final String estado;
  final String? comentarioMinisterio;
  final String? codigo;
  final String usuarioId;

  Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.foto,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    this.estado = 'Pendiente',
    this.comentarioMinisterio,
    this.codigo,
    required this.usuarioId,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'],
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      foto: json['foto']?.toString(),
      latitud: double.tryParse(json['latitud']?.toString() ?? '0') ?? 0.0,
      longitud: double.tryParse(json['longitud']?.toString() ?? '0') ?? 0.0,
      fecha: json['fecha']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'Pendiente',
      comentarioMinisterio: json['comentario_ministerio']?.toString(),
      codigo: json['codigo']?.toString(),
      usuarioId: json['usuario_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'foto': foto,
      'latitud': latitud.toString(),
      'longitud': longitud.toString(),
      'fecha': fecha,
      'usuario_id': usuarioId,
    };
  }
}
