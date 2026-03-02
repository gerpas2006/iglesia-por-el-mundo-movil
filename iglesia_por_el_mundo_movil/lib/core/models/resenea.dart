class UserReseneaResponse {
  final int id;
  final String name;
  final String email;
  final String role;

  UserReseneaResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserReseneaResponse.fromJson(Map<String, dynamic> json) {
    return UserReseneaResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}

class ReseneaResponse {
  final int id;
  final String tituloReseneas;
  final int calificacionResenea;
  final String comentarioResenea;
  final String fechaResenea;
  final int userId;
  final UserReseneaResponse? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReseneaResponse({
    required this.id,
    required this.tituloReseneas,
    required this.calificacionResenea,
    required this.comentarioResenea,
    required this.fechaResenea,
    required this.userId,
    this.user,
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
      userId: json['user_id'] as int,
      user: json['user'] != null
          ? UserReseneaResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
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
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}