import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> buscarCep(String cep) async {
  final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data.containsKey('erro')) return null;
    return data;
  } else {
    return null;
  }
}
