class ReseneaDTO {
  final String tituloReseneas;
  final int calificacionResenea;
  final String comentarioResenea;
  final String fechaResenea;

  ReseneaDTO({
    required this.tituloReseneas,
    required this.calificacionResenea,
    required this.comentarioResenea,
    required this.fechaResenea,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo_reseneas': tituloReseneas,
      'calificacion_resenea': calificacionResenea,
      'comentario_resenea': comentarioResenea,
      'fecha_resenea': fechaResenea,
    };
  }
}