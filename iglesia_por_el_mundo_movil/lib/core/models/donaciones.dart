class TipoDonacion {
  final int? id;
  final String? nombreDonacion;
  final String? descripcionDonacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TipoDonacion({
    this.id,
    this.nombreDonacion,
    this.descripcionDonacion,
    this.createdAt,
    this.updatedAt,
  });

  factory TipoDonacion.fromJson(Map<String, dynamic> json) {
    return TipoDonacion(
      id: json['id'],
      nombreDonacion: json['nombre_donacion'],
      descripcionDonacion: json['descripcion_donacion'],
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
      'nombre_donacion': nombreDonacion,
      'descripcion_donacion': descripcionDonacion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class DonacionResponse {
  final int? id;
  final String? nombreDonante;
  final String? apellidoDonante;
  final double? donacion;
  final String? mensaje;
  final DateTime? fechaDonacion;
  final String? metodo;
  final int? userId;
  final int? tipoDonacionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TipoDonacion? tipoDonacion;

  DonacionResponse({
    this.id,
    this.nombreDonante,
    this.apellidoDonante,
    this.donacion,
    this.mensaje,
    this.fechaDonacion,
    this.metodo,
    this.userId,
    this.tipoDonacionId,
    this.createdAt,
    this.updatedAt,
    this.tipoDonacion,
  });

  factory DonacionResponse.fromJson(Map<String, dynamic> json) {
    try {
      return DonacionResponse(
        id: json['id'] as int?,
        nombreDonante: json['nombre_donante'] as String?,
        apellidoDonante: json['apellido_donante'] as String?,
        // Importante: usar 'num' y luego toDouble() maneja tanto int (50) como double (75.5)
        donacion: (json['donacion'] as num?)?.toDouble(),
        mensaje: json['mensaje'] as String?,
        fechaDonacion: json['fecha_donacion'] != null 
            ? DateTime.tryParse(json['fecha_donacion'].toString()) 
            : null,
        metodo: json['metodo'] as String?,
        userId: json['user_id'] as int?,
        tipoDonacionId: json['tipo_donacion_id'] as int?,
        createdAt: json['created_at'] != null 
            ? DateTime.tryParse(json['created_at'].toString()) 
            : null,
        updatedAt: json['updated_at'] != null 
            ? DateTime.tryParse(json['updated_at'].toString()) 
            : null,
        tipoDonacion: json['tipo_donacion'] != null
            ? TipoDonacion.fromJson(json['tipo_donacion'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_donante': nombreDonante,
      'apellido_donante': apellidoDonante,
      'donacion': donacion,
      'mensaje': mensaje,
      // Formateamos fecha corta (solo YYYY-MM-DD) si es necesario
      'fecha_donacion': fechaDonacion?.toIso8601String().substring(0, 10),
      'metodo': metodo,
      'user_id': userId,
      'tipo_donacion_id': tipoDonacionId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tipo_donacion': tipoDonacion?.toJson(),
    };
  }
  
  // Helper para obtener lista desde JSON array
  static List<DonacionResponse> listFromJson(List<dynamic> list) {
    return list.map((item) => DonacionResponse.fromJson(item)).toList();
  }
}