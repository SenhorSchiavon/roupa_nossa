import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchRoupas() async {
  final response = await http.get(
    Uri.parse('${dotenv.env['URL_BACKEND']}/api/roupa'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Erro ao buscar roupas');
  }
}
