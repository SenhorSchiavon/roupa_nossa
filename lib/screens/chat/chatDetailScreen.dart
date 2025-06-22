import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:roupa_nossa/services/map/mapService.dart';
import 'package:roupa_nossa/components/ui/location_message_bubble.dart';
import 'package:http/http.dart' as http;

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final chatId = widget.chat['id'];
    final mensagemTexto = _messageController.text.trim();

    final messageData = {
      'text': mensagemTexto,
      'senderId': user.uid,
      'senderName': user.displayName ?? 'Usuário',
      'timestamp': DateTime.now(),
    };

    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messagesRef.add(messageData);

    // atualiza resumo
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'lastMessage': mensagemTexto,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2196F3),
              const Color(0xFF2196F3).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: _buildMessageList()),
                        _buildMessageInput(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final participants = List<String>.from(widget.chat['participants'] ?? []);
    final rawUsers = widget.chat['users'] as Map<dynamic, dynamic>? ?? {};
    final users = rawUsers.map(
      (key, value) => MapEntry(key.toString(), value as Map<String, dynamic>),
    );

    final otherUid = participants.firstWhere(
      (uid) => uid != currentUid,
      orElse: () => '',
    );

    final userData = users[otherUid];

    final otherName = userData?['nome'] ?? 'Contato';
    final avatarUrl = userData?['avatar'] ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final String chatId = widget.chat['id'];

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final isMe =
                data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
            final timestamp = (data['timestamp'] as Timestamp).toDate();

            final message = {
              'text': data['text'],
              'timestamp': timestamp,
              'isMe': isMe,
              'type': data['type'], // <- OK até aqui
              // FALTOU ISSO:
              'locationName': data['locationName'],
            };

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );

            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isMe = message['isMe'] as bool;
    final DateTime timestamp = message['timestamp'] as DateTime;
    final String messageType = message['type'] ?? 'text';

    if (messageType == 'location') {
      return LocationMessageBubble(
        isMe: isMe,
        timestamp: timestamp,
        locationName: message['locationName'] ?? 'Localização compartilhada',
      );
    }

    // Mensagem de texto normal (código existente)
    final timeString = DateFormat('HH:mm').format(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF2196F3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : null,
            bottomLeft: !isMe ? const Radius.circular(0) : null,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeString,
                style: TextStyle(
                  color:
                      isMe ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.location_on, color: Color(0xFF2196F3)),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final chatId = widget.chat['id'];

                final response = await http.get(
                  Uri.parse(
                    '${dotenv.env['URL_BACKEND']}/api/usuario/firebase/${user.uid}',
                  ),
                );

                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  final endereco =
                      '${data['endereco']} ${data['numero']}, ${data['cidade']} - ${data['estado']}, ${data['cep']}';
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
                        'type': 'location',
                        'locationName': endereco,
                      });

                  await FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .update({
                        'lastMessage': '📍 Endereço enviado',
                        'lastTimestamp': FieldValue.serverTimestamp(),
                      });

                  _scrollToBottom();
                } else {
                  print('Erro ao buscar endereço do usuário: ${response.body}');
                }
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Digite uma mensagem...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
