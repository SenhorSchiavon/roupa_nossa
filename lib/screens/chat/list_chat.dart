// Este arquivo ainda está com os dados mockados. Para funcionar com Firestore:
// - Vamos substituir a lista `chats` por uma `StreamBuilder`
// - Pegar os dados da coleção `chats`

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roupa_nossa/screens/chat/chatDetailScreen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

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
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _buildChatStream(context), // <-- aqui
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatStream(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Usuário não logado"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .where('participants', arrayContains: user.uid)
              .orderBy('lastTimestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: docs.length,
          separatorBuilder:
              (_, __) => Divider(height: 1, color: Colors.grey[200]),
          itemBuilder: (context, index) {
            final chat = docs[index];
            final data = chat.data() as Map<String, dynamic>;

            return _buildChatItem(context, {
              'id': chat.id,
              'participants': data['participants'],
              'users': data['users'],
              'lastMessage': data['lastMessage'] ?? '',
              'timestamp':
                  (data['lastTimestamp'] as Timestamp?)?.toDate() ??
                  DateTime(2000),
              'unread': 0,
            });
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            'Mensagens',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pesquisar conversas...',
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
    final usersMap = chat['users'] as Map<String, dynamic>? ?? {};
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    String name = 'Contato';
    String avatar = '';

    usersMap.forEach((uid, data) {
      if (uid != currentUid) {
        name = data['nome'] ?? 'Contato';
        avatar = data['avatar'] ?? '';
      }
    });

    final DateTime timestamp = chat['timestamp'] as DateTime;
    final String timeText = _getTimeText(timestamp);
    final bool hasUnread = (chat['unread'] as int) > 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatDetailScreen(
                  chat: {...chat, 'name': name, 'avatar': avatar},
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatar)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeText,
                        style: TextStyle(
                          color:
                              hasUnread
                                  ? const Color(0xFF2196F3)
                                  : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            color:
                                hasUnread ? Colors.black87 : Colors.grey[600],
                            fontWeight:
                                hasUnread ? FontWeight.w500 : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma conversa encontrada',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Suas conversas aparecerão aqui',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getTimeText(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365)
      return DateFormat('dd/MM/yyyy').format(timestamp);
    if (difference.inDays > 7) return DateFormat('dd/MM').format(timestamp);
    if (difference.inDays > 0)
      return difference.inDays == 1 ? 'Ontem' : '${difference.inDays} dias';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Agora';
  }
}
