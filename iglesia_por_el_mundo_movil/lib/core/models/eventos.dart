class TipoEvento {
  final int? id;
  final String? nombreEvento;
  final String? descripcionEvento;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TipoEvento({
    this.id,
    this.nombreEvento,
    this.descripcionEvento,
    this.createdAt,
    this.updatedAt,
  });

  factory TipoEvento.fromJson(Map<String, dynamic> json) {
    return TipoEvento(
      id: json['id'],
      nombreEvento: json['nombre_evento'],
      descripcionEvento: json['descripcion_evento'],
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
      'nombre_evento': nombreEvento,
      'descripcion_evento': descripcionEvento,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class EventoResponse {
  final int? id;
  final String? nombreEvento;
  final DateTime? fechaEvento;
  final String? ubicacion;
  final String? descripcionEvento;
  final int? estado; // Nota: En este JSON el estado es un número (1, 2)
  final int? userId;
  final int? tipoEventoId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TipoEvento? tipoEvento;

  EventoResponse({
    this.id,
    this.nombreEvento,
    this.fechaEvento,
    this.ubicacion,
    this.descripcionEvento,
    this.estado,
    this.userId,
    this.tipoEventoId,
    this.createdAt,
    this.updatedAt,
    this.tipoEvento,
  });

  factory EventoResponse.fromJson(Map<String, dynamic> json) {
    return EventoResponse(
      id: json['id'],
      nombreEvento: json['nombre_evento'],
      fechaEvento: json['fecha_evento'] != null 
          ? DateTime.tryParse(json['fecha_evento']) 
          : null,
      ubicacion: json['ubicacion'],
      descripcionEvento: json['descripcion_evento'],
      estado: json['estado'],
      userId: json['user_id'],
      tipoEventoId: json['tipo_evento_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      tipoEvento: json['tipo_evento'] != null
          ? TipoEvento.fromJson(json['tipo_evento'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_evento': nombreEvento,
      'fecha_evento': fechaEvento?.toString(), // Guarda formato "2025-12-20 00:00:00"
      'ubicacion': ubicacion,
      'descripcion_evento': descripcionEvento,
      'estado': estado,
      'user_id': userId,
      'tipo_evento_id': tipoEventoId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tipo_evento': tipoEvento?.toJson(),
    };
  }

  // Método helper para convertir la lista completa
  static List<EventoResponse> listFromJson(List<dynamic> list) {
    return list.map((item) => EventoResponse.fromJson(item)).toList();
  }
}