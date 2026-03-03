class ReseneaDTO {
  final String tituloReseneas;
  final int calificacionResenea;
  final String comentarioResenea;

  ReseneaDTO({
    required this.tituloReseneas,
    required this.calificacionResenea,
    required this.comentarioResenea,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo_reseneas': tituloReseneas,
      'calificacion_resenea': calificacionResenea,
      'comentario_resenea': comentarioResenea,
    };
  }
}