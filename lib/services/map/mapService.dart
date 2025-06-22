import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<void> enviarEnderecoDoUsuario({required String chatId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final response = await http.get(
      Uri.parse(
        '${dotenv.env['URL_BACKEND']}/api/usuario/firebase/${user.uid}',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final endereco =
          '${data['endereco']}, ${data['cidade']} - ${data['estado']}, ${data['cep']}';
      print('Endereço do usuário: $endereco');
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'text': '📍 Meu endereço: $endereco',
            'senderId': user.uid,
            'senderName': user.displayName ?? 'Usuário',
            'timestamp': DateTime.now(),
          });

      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': '📍 Endereço enviado',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
    } else {
      print('Erro ao buscar endereço do usuário: ${response.body}');
    }
  }
}
