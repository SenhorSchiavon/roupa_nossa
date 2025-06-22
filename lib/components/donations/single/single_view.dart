import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roupa_nossa/commons/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DonationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> donation;

  const DonationDetailsScreen({Key? key, required this.donation})
    : super(key: key);

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  bool _isInterested = false;
  bool _isLoadingInterest = false;

  @override
  void initState() {
    super.initState();
    _checkIfInterested();
  }

  Future<void> _checkIfInterested() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('id'); // 👈 usuário logado
      final donoId = widget.donation['usuario']['id']; // doador
      final doacaoId = widget.donation['id'];

      if (usuarioId == null || usuarioId == donoId) return;

      final response = await http.get(
        Uri.parse(
          '${dotenv.env['URL_BACKEND']}/api/interesse/byUserAndDonation?usuarioId=$usuarioId&doacaoId=$doacaoId',
        ),
      );

      setState(() => _isInterested = response.statusCode == 200);
    } catch (e) {
      print('Erro ao verificar interesse: $e');
    }
  }

  Future<void> _toggleInterest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('id');
      final doacaoId = widget.donation['id'];

      if (usuarioId == null || doacaoId == null) {
        print('❌ Usuário ou doação inválidos');
        return;
      }
      print('🔄 Toggling interest: usuarioId=$usuarioId, doacaoId=$doacaoId');
      setState(() {
        _isLoadingInterest = true;
      });

      final urlBase = '${dotenv.env['URL_BACKEND']}/api/interesse';

      if (_isInterested) {
        print(
          '🔴 Removendo interesse: usuarioId=$usuarioId, doacaoId=$doacaoId',
        );

        final response = await http.delete(
          Uri.parse(
            '$urlBase/byUserAndDonation?usuarioId=$usuarioId&doacaoId=$doacaoId',
          ),
        );

        print('🔴 DELETE statusCode: ${response.statusCode}');
        print('🔴 DELETE response: ${response.body}');

        if (response.statusCode == 204) {
          setState(() {
            _isInterested = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Interesse removido!"),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception('Erro ao deletar interesse');
        }
      } else {
        final response = await http.post(
          Uri.parse(urlBase),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'usuarioId': usuarioId, 'doacaoId': doacaoId}),
        );

        if (response.statusCode == 201) {
          setState(() {
            _isInterested = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Adicionado aos seus interesses!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception('Erro ao criar interesse');
        }
      }
    } catch (e) {
      print('Erro ao gerenciar interesse: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao salvar interesse. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingInterest = false;
      });
    }
  }

  String _interestIdFromWidget() {
    return widget.donation['id'].toString();
  }

  Future<void> _abrirChat(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final dono = widget.donation['usuario'];
      final roupa = widget.donation['roupa'];

      if (currentUser == null) return;

      final currentUserId = currentUser.uid;
      final donoUid = dono['firebaseUid'];
      if (donoUid == null || donoUid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: UID do doador não encontrado.")),
        );
        return;
      }

      final chatId = [currentUserId, donoUid]..sort();
      final chatDocId = chatId.join('_');

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId);
      final messagesRef = chatRef.collection('messages');

      final chatDoc = await chatRef.get();
      final nomeDono = dono['nome'] ?? 'Contato';
      final avatarDono =
          dono['imageUrl'] ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nomeDono)}';

      if (!chatDoc.exists) {
        await chatRef.set({
          'participants': [currentUserId, donoUid],
          'users': {
            currentUserId: {
              'nome': currentUser.displayName ?? 'Você',
              'avatar':
                  currentUser.photoURL ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(currentUser.displayName ?? 'Você')}',
            },
            donoUid: {'nome': nomeDono, 'avatar': avatarDono},
          },
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage':
              "Olá, vi sua doação '${roupa['nome']}' e tenho interesse!",
          'lastTimestamp': FieldValue.serverTimestamp(),
        });

        await messagesRef.add({
          'text': "Olá, vi sua doação '${roupa['nome']}' e tenho interesse!",
          'senderId': currentUserId,
          'senderName': currentUser.displayName ?? 'Usuário',
          'timestamp': DateTime.now(),
        });
      }

      Navigator.pushReplacementNamed(
        context,
        NamedRoutes.chat,
        arguments: {
          'id': chatDocId,
          'participants': [currentUserId, donoUid],
          'users': {
            currentUserId: {
              'nome': currentUser.displayName ?? 'Você',
              'avatar':
                  currentUser.photoURL ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(currentUser.displayName ?? 'Você')}',
            },
            donoUid: {
              'nome': dono['nome'] ?? 'Contato',
              'avatar':
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(dono['nome'])}',
            },
          },
          'lastMessage':
              "Olá, vi sua doação '${roupa['nome']}' e tenho interesse!",
          'timestamp': DateTime.now(),
          'unread': 0,
        },
      );
    } catch (e) {
      print('Erro ao abrir o chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Não foi possível abrir o chat. Verifique sua conexão.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roupa = widget.donation['roupa'];
    final usuario = widget.donation['usuario'];
    final donatedDate = DateTime.parse(widget.donation['dataCadastro']);
    final formattedDate = DateFormat('dd/MM/yyyy').format(donatedDate);

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem com botão de interesse
                            Stack(
                              children: [
                                Hero(
                                  tag:
                                      'donation-image-${widget.donation['id']}',
                                  child: Image.network(
                                    roupa['imagemUrl'],
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: GestureDetector(
                                    onTap:
                                        _isLoadingInterest
                                            ? null
                                            : _toggleInterest,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child:
                                          _isLoadingInterest
                                              ? SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xFF2196F3)),
                                                ),
                                              )
                                              : Icon(
                                                _isInterested
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    _isInterested
                                                        ? Colors.red
                                                        : Colors.grey[600],
                                                size: 24,
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Conteúdo
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    roupa['nome'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF2196F3,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          roupa['categoria'],
                                          style: const TextStyle(
                                            color: Color(0xFF2196F3),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'Tamanho: ${roupa['tamanho']}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  Text(
                                    'Descrição',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    roupa['descricao'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Informações da doação',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: const Color(
                                                0xFF2196F3,
                                              ).withOpacity(0.1),
                                              child: Text(
                                                usuario['nome'][0]
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Color(0xFF2196F3),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usuario['nome'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  'Doado em $formattedDate',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Botões de ação
                                  FirebaseAuth.instance.currentUser?.uid ==
                                          widget
                                              .donation['usuario']['firebaseUid']
                                      ? Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: _marcarComoDoada,
                                              icon: const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Finalizar',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: _confirmarExclusao,
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Excluir',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _abrirChat(context),
                                          icon: const Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Entrar em contato',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF25D366,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _marcarComoDoada() async {
    final doacaoId = widget.donation['id'];

    try {
      final response = await http.put(
        Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao/$doacaoId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'foiDoada': true}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doação marcada como finalizada!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // volta pra tela anterior
      } else {
        throw Exception('Falha ao atualizar doação');
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao marcar como doada.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmarExclusao() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Excluir doação'),
            content: const Text('Tem certeza que deseja excluir esta doação?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final doacaoId = widget.donation['id'];
      final response = await http.delete(
        Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao/$doacaoId'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doação excluída com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Erro ao excluir');
      }
    } catch (e) {
      print('Erro ao excluir doação: $e');
      if (e is http.Response) {
        print('⚠️ Erro HTTP: ${e.statusCode} - ${e.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir doação.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
          const SizedBox(width: 16),
          const Text(
            'Detalhes da Doação',
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
}
