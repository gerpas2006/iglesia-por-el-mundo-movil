import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/resenea_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/resenea_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/resenea.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class ReseneaService implements ReseneaInterface{
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService(); 

  @override
  Future<List<ReseneaResponse>> getAllResenea() async {
    final token = await _tokenService.getToken(); 

    var url = Uri.parse('$_baseUrl/reseneas');

    try{
      var response = await http.get(url,headers:{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
      });
      if(response.statusCode>=200 && response.statusCode <=300){
        var jsonData = json.decode(response.body);


        List<ReseneaResponse> listaResenea = [];
        if(jsonData is List){
          listaResenea = jsonData.map((resenea) => ReseneaResponse.fromJson(resenea)).toList();
        }
        return listaResenea;
      }else{
        throw Exception("Error al obtener las reseñas.");
      }
    }catch (e){
      throw Exception("Error al obtener las oraciones: $e");
    }
  }

  @override
  Future<ReseneaResponse> crearResenea(ReseneaDTO resenea) {
    final token = _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/reseneas');
      return token.then((token) async {
        try {
          var response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'titulo_resenea': resenea.titulo_resenea,
              'descripcion_resenea': resenea.descripcion_resenea,
              'comentarios_resenea': resenea.comentarios_resenea,
              'fecha_resenea': resenea.fecha_resenea,
              'user_id': resenea.user_id,
            }),
          );
  
          if (response.statusCode >= 200 && response.statusCode <= 300) {
            var jsonData = json.decode(response.body);
            return ReseneaResponse.fromJson(jsonData);
          } else {
            throw Exception("Error al crear la reseña.");
          }
        } catch (e) {
          throw Exception("Error al crear la reseña: $e");
        }
      });
  }
}