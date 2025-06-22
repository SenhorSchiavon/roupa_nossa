import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DoacaoService {
  static final DoacaoService _instance = DoacaoService._internal();

  factory DoacaoService() {
    return _instance;
  }

  DoacaoService._internal();

  Future<List<Map<String, dynamic>>> fetchRoupas() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar roupas');
    }
  }

  Future<Map<String, dynamic>> updateDoacao(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    final response = await http.put(
      Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao atualizar doação');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoacoesFinalizadas() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao/finalizadas'),
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao carregar doações finalizadas');
    }
  }
}
