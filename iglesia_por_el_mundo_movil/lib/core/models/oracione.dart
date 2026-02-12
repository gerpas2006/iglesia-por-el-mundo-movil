class OracionResponse {
  final int id;
  final String nombreOracion;
  final String textoOracion;
  final String autor;
  final int estado;
  final int tipoOracionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TipoOracion? tipoOracion;

  OracionResponse({
    required this.id,
    required this.nombreOracion,
    required this.textoOracion,
    required this.autor,
    required this.estado,
    required this.tipoOracionId,
    required this.createdAt,
    required this.updatedAt,
    this.tipoOracion,
  });

  factory OracionResponse.fromJson(Map<String, dynamic> json) {
    return OracionResponse(
      id: json['id'],
      nombreOracion: json['nombre_oracion'],
      textoOracion: json['texto_oracion'],
      autor: json['autor'],
      estado: json['estado'],
      tipoOracionId: json['tipo_oracion_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tipoOracion: json['tipo_oracion'] != null
          ? TipoOracion.fromJson(json['tipo_oracion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_oracion': nombreOracion,
      'texto_oracion': textoOracion,
      'autor': autor,
      'estado': estado,
      'tipo_oracion_id': tipoOracionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tipo_oracion': tipoOracion?.toJson(),
    };
  }
}

class TipoOracion {
  final int id;
  final String nombreOracion;
  final String descripcionOracion;
  final DateTime createdAt;
  final DateTime updatedAt;

  TipoOracion({
    required this.id,
    required this.nombreOracion,
    required this.descripcionOracion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TipoOracion.fromJson(Map<String, dynamic> json) {
    return TipoOracion(
      id: json['id'],
      nombreOracion: json['nombre_oracion'],
      descripcionOracion: json['descripcion_oracion'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_oracion': nombreOracion,
      'descripcion_oracion': descripcionOracion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}