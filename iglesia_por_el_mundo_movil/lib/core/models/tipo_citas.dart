class TipoCitaResponse {
  final int id;
  final String nombreCita;
  final String descripcionCita;
  final DateTime createdAt;
  final DateTime updatedAt;

  TipoCitaResponse({
    required this.id,
    required this.nombreCita,
    required this.descripcionCita,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TipoCitaResponse.fromJson(Map<String, dynamic> json) {
    return TipoCitaResponse(
      id: json['id'] as int,
      nombreCita: json['nombre_cita'] as String,
      descripcionCita: json['descripcion_cita'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_cita': nombreCita,
      'descripcion_cita': descripcionCita,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoCitaResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombreCita == other.nombreCita;

  @override
  int get hashCode => id.hashCode ^ nombreCita.hashCode;
}
