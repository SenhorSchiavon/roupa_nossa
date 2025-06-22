import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class InteresseService {
  static final InteresseService _instance = InteresseService._internal();

  factory InteresseService() {
    return _instance;
  }

  InteresseService._internal();

  final String baseUrl = '${dotenv.env['URL_BACKEND']}/api/interesse';

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar interesses');
    }
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar interesse');
    }
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao criar interesse');
    }
  }

  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao atualizar interesse');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao excluir interesse');
    }
  }

  Future<void> deleteByUserAndDonation(int usuarioId, int doacaoId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/byUserAndDonation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuarioId': usuarioId, 'doacaoId': doacaoId}),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao excluir interesse pelo usuário e doação');
    }
  }

  Future<Map<String, dynamic>?> getByUserAndDonation(
    int usuarioId,
    int doacaoId,
  ) async {
    final uri = Uri.parse('$baseUrl/byUserAndDonation').replace(
      queryParameters: {
        'usuarioId': usuarioId.toString(),
        'doacaoId': doacaoId.toString(),
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body.isEmpty ? null : body;
    } else {
      throw Exception('Erro ao verificar interesse');
    }
  }

  Future<List<Map<String, dynamic>>> getFavoritosByUsuario(
    int usuarioId,
  ) async {
    final url =
        '${dotenv.env['URL_BACKEND']}/api/interesse/favoritos/$usuarioId';
    print('🌐 Chamando: $url');

    final response = await http.get(Uri.parse(url));
    print('📥 Status da resposta: ${response.statusCode}');
    print('📦 Body: ${response.body}');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print('🎯 Favoritos retornados: $data');
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar favoritos');
    }
  }
}
