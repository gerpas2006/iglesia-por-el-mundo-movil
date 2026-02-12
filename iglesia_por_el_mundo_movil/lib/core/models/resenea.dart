class ReseneaResponse {
  final int id;
  final String tituloReseneas;
  final int calificacionResenea;
  final String comentarioResenea;
  final String fechaResenea;
  final String usuario;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReseneaResponse({
    required this.id,
    required this.tituloReseneas,
    required this.calificacionResenea,
    required this.comentarioResenea,
    required this.fechaResenea,
    required this.usuario,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReseneaResponse.fromJson(Map<String, dynamic> json) {
    return ReseneaResponse(
      id: json['id'] as int,
      tituloReseneas: json['titulo_reseneas'] as String,
      calificacionResenea: json['calificacion_resenea'] as int,
      comentarioResenea: json['comentario_resenea'] as String,
      fechaResenea: json['fecha_resenea'] as String,
      usuario: json['usuario'] as String,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo_reseneas': tituloReseneas,
      'calificacion_resenea': calificacionResenea,
      'comentario_resenea': comentarioResenea,
      'fecha_resenea': fechaResenea,
      'usuario': usuario,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}