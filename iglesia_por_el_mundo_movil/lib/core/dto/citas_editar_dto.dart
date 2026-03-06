class CitasEditarDto {
  final int id;
  final String nombre_solicitante;
  final String apellido_solicitante;
  final DateTime fecha_y_hora_cita;
  final String mensaje;
  final String contacto;
  final int tipo_cita_id;
  final String estado; // Campo requerido por el backend

  CitasEditarDto({
    required this.id,
    required this.nombre_solicitante,
    required this.apellido_solicitante,
    required this.fecha_y_hora_cita,
    required this.mensaje,
    required this.contacto,
    required this.tipo_cita_id,
    required this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre_solicitante': nombre_solicitante,
      'apellido_solicitante': apellido_solicitante,
      'fecha_y_hora_cita': fecha_y_hora_cita.toIso8601String(),
      'mensaje': mensaje,
      'contacto': contacto,
      'tipo_cita_id': tipo_cita_id,
      'estado': estado,
    };
  }

  factory CitasEditarDto.fromJson(Map<String, dynamic> json) {
    return CitasEditarDto(
      id: json['id'] as int,
      nombre_solicitante: json['nombre_solicitante'] as String,
      apellido_solicitante: json['apellido_solicitante'] as String,
      fecha_y_hora_cita: DateTime.parse(json['fecha_y_hora_cita'] as String),
      mensaje: json['mensaje'] as String,
      contacto: json['contacto'].toString(),
      tipo_cita_id: json['tipo_cita_id'] as int,
      estado: json['estado'] as String,
    );
  }
}
