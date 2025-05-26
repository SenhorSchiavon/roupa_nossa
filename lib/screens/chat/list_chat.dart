import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roupa_nossa/screens/chat/chatDetailScreen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data for chat conversations
    final List<Map<String, dynamic>> chats = [
      {
        'id': '1',
        'name': 'Maria Silva',
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
        'lastMessage': 'Olá! Tenho interesse na sua doação de camiseta azul.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'unread': 2,
      },
      {
        'id': '2',
        'name': 'João Pedro',
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
        'lastMessage': 'Obrigado pela doação! Ficou perfeito.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'unread': 0,
      },
      {
        'id': '3',
        'name': 'Ana Carolina',
        'avatar': 'https://randomuser.me/api/portraits/women/68.jpg',
        'lastMessage': 'Posso buscar amanhã à tarde?',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'unread': 0,
      },
      {
        'id': '4',
        'name': 'Carlos Mendes',
        'avatar': 'https://randomuser.me/api/portraits/men/55.jpg',
        'lastMessage': 'Você ainda tem aquela calça jeans disponível?',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'unread': 0,
      },
      {
        'id': '5',
        'name': 'Fernanda Lima',
        'avatar': 'https://randomuser.me/api/portraits/women/33.jpg',
        'lastMessage': 'Adorei o vestido! Muito obrigada pela doação.',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'unread': 0,
      },
    ];

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
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child:
                          chats.isEmpty
                              ? _buildEmptyState()
                              : _buildChatList(context, chats),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Text(
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
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pesquisar conversas...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
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

  Widget _buildChatList(
    BuildContext context,
    List<Map<String, dynamic>> chats,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: chats.length,
      separatorBuilder:
          (context, index) =>
              Divider(color: Colors.grey[200], height: 1, indent: 80),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatItem(context, chat);
      },
    );
  }

  Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
    final DateTime timestamp = chat['timestamp'] as DateTime;
    final String timeText = _getTimeText(timestamp);
    final bool hasUnread = (chat['unread'] as int) > 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailScreen(chat: chat)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chat['avatar']),
            ),
            const SizedBox(width: 16),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat['name'],
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

  String _getTimeText(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else if (difference.inDays > 7) {
      return DateFormat('dd/MM').format(timestamp);
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Ontem';
      }
      return '${difference.inDays} dias';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Agora';
    }
  }
}
