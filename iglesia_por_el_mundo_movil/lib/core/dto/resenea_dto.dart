class ReseneaDTO {
  String titulo_resenea;
  String descripcion_resenea;
  String comentarios_resenea;
  String fecha_resenea;
  int user_id;
  ReseneaDTO({
    required this.titulo_resenea,
    required this.descripcion_resenea,
    required this.comentarios_resenea,
    required this.fecha_resenea,
    required this.user_id
  });

     Map<String, dynamic> toJson() { 
    return {  'titulo_resenea': titulo_resenea,
              'descripcion_resenea': descripcion_resenea,
              'comentarios_resenea': comentarios_resenea,
              'fecha_resenea': fecha_resenea,
              'user_id': user_id
              };
}
}