class TipoDonacionResponse {
  final int id;
  final String nombreDonacion;
  final String descripcionDonacion;
  final DateTime createdAt;
  final DateTime updatedAt;

  TipoDonacionResponse({
    required this.id,
    required this.nombreDonacion,
    required this.descripcionDonacion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TipoDonacionResponse.fromJson(Map<String, dynamic> json) {
    return TipoDonacionResponse(
      id: json['id'] as int,
      nombreDonacion: json['nombre_donacion'] as String,
      descripcionDonacion: json['descripcion_donacion'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_donacion': nombreDonacion,
      'descripcion_donacion': descripcionDonacion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
