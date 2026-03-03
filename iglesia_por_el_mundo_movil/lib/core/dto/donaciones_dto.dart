enum MetrodoPago {
  bizum,
  tarjeta,
  PayPal,
}
class DonacionesDto {
  final String nombre_donante;
  final String apellido_donante;
  final double donacion;
  final String mensaje;
  final MetrodoPago metodoPago;
  final int tipo_donacion_id;
  final int? user_id; // Agrega el user_id del usuario autenticado

  DonacionesDto({
    required this.nombre_donante,
    required this.apellido_donante,
    required this.donacion,
    required this.mensaje,
    required this.metodoPago,
    required this.tipo_donacion_id,
    this.user_id,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'nombre_donante': nombre_donante,
      'apellido_donante': apellido_donante,
      'donacion': donacion,
      'mensaje': mensaje,
      'metodo': metodoPago.toString().split('.').last, // Convertir enum a string (bizum, tarjeta, PayPal)
      'tipo_donacion_id': tipo_donacion_id,
    };
    
    // Incluir user_id si está disponible
    if (user_id != null) {
      json['user_id'] = user_id!;
    }
    
    return json;
  }
  }