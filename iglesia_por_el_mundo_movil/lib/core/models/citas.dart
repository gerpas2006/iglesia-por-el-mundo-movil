class TipoCita {
  final int? id;
  final String? nombreCita;
  final String? descripcionCita;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TipoCita({
    this.id,
    this.nombreCita,
    this.descripcionCita,
    this.createdAt,
    this.updatedAt,
  });

  factory TipoCita.fromJson(Map<String, dynamic> json) {
    return TipoCita(
      id: json['id'],
      nombreCita: json['nombre_cita'],
      descripcionCita: json['descripcion_cita'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_cita': nombreCita,
      'descripcion_cita': descripcionCita,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CitaResponse {
  final int? id;
  final String? nombreSolicitante;
  final String? apellidoSolicitante;
  final DateTime? fechaYHoraCita;
  final String? mensaje;
  final String? estado;
  final String? contacto;
  final int? tipoCitaId;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TipoCita? tipoCita;

  CitaResponse({
    this.id,
    this.nombreSolicitante,
    this.apellidoSolicitante,
    this.fechaYHoraCita,
    this.mensaje,
    this.estado,
    this.contacto,
    this.tipoCitaId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.tipoCita,
  });

  // Getter útil para mostrar nombre completo en la UI
  String get nombreCompleto => "${nombreSolicitante ?? ''} ${apellidoSolicitante ?? ''}".trim();

  factory CitaResponse.fromJson(Map<String, dynamic> json) {
    return CitaResponse(
      id: json['id'],
      nombreSolicitante: json['nombre_solicitante'],
      apellidoSolicitante: json['apellido_solicitante'],
      fechaYHoraCita: json['fecha_y_hora_cita'] != null 
          ? DateTime.tryParse(json['fecha_y_hora_cita']) 
          : null,
      mensaje: json['mensaje'],
      estado: json['estado'],
      contacto: json['contacto'],
      tipoCitaId: json['tipo_cita_id'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      tipoCita: json['tipo_cita'] != null
          ? TipoCita.fromJson(json['tipo_cita'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_solicitante': nombreSolicitante,
      'apellido_solicitante': apellidoSolicitante,
      // Convertimos la fecha al formato string esperado por tu JSON
      'fecha_y_hora_cita': fechaYHoraCita?.toString(), 
      'mensaje': mensaje,
      'estado': estado,
      'contacto': contacto,
      'tipo_cita_id': tipoCitaId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tipo_cita': tipoCita?.toJson(),
    };
  }

  // Método estático para convertir la lista completa del JSON
  static List<CitaResponse> listFromJson(List<dynamic> list) {
    return list.map((item) => CitaResponse.fromJson(item)).toList();
  }
}