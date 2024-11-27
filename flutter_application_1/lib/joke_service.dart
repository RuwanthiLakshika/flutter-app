import 'package:dio/dio.dart';

class JokeService{
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchJokesRaw() async {
    try{
      final response = await _dio.get('https://v2.jokeapi.dev/joke/Any\?amount\=3&blacklistFlags\=nsfw');
      if(response.statusCode == 200){
        final List<dynamic> jokesJson = response.data['jokes'];
        return jokesJson.cast<Map<String, dynamic>>();
      }else{
        throw Exception('Failed to load jokes');
      }
    }catch(e){
      throw Exception('Failed to load jokes: $e');
    }
  }
}