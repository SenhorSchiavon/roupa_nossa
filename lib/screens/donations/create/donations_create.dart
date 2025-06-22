import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationRegistrationScreen extends StatefulWidget {
  const DonationRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DonationRegistrationScreen> createState() =>
      _DonationRegistrationScreenState();
}

class _DonationRegistrationScreenState
    extends State<DonationRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _title = '';
  String _description = '';
  String _size = '';
  String _category = 'Camisetas';
  File? _imageFile;
  bool _disponivel = true;

  final List<String> _categories = [
    'Camisetas',
    'Calças',
    'Calçados',
    'Vestidos',
    'Outros',
  ];

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: this.context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tirar foto'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Selecionar da galeria'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final uriRoupa = Uri.parse('${dotenv.env['URL_BACKEND']}/api/roupa');
      final uriDoacao = Uri.parse('${dotenv.env['URL_BACKEND']}/api/doacao');

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('id');

        if (userId == null) {
          throw Exception('Usuário não autenticado');
        }

        String imageUrl = '';

        if (_imageFile != null) {
          final fileName = basename(_imageFile!.path);
          final storageRef = FirebaseStorage.instance.ref().child(
            'doacoes/$fileName',
          );

          final uploadTask = await storageRef.putFile(_imageFile!);
          imageUrl = await uploadTask.ref.getDownloadURL();
          print('URL gerada: $imageUrl');
        } else {
          imageUrl =
              'https://images.tcdn.com.br/img/img_prod/978582/camiseta_poliester_azul_royal_p_linha_sublima_brasil_2143_1_25dda3f2548c3bcba314654a02c7ced8.png';
        }
        print(
          json.encode({
            'nome': _title,
            'categoria': _category,
            'tamanho': _size,
            'descricao': _description,
            'imagemUrl': imageUrl,
            'disponibilidade': true,
          }),
        );

        // 1. Envia a roupa
        final responseRoupa = await http.post(
          uriRoupa,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nome': _title,
            'categoria': _category,
            'tamanho': _size,
            'descricao': _description,
            'imagemUrl': imageUrl,
            'disponibilidade': true,
          }),
        );

        if (responseRoupa.statusCode == 201) {
          final roupaData = json.decode(responseRoupa.body);
          final roupaId = roupaData['id'];

          // 2. Cadastra a doação
          final responseDoacao = await http.post(
            uriDoacao,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'usuarioId': userId,
              'roupaId': roupaId,
              'status': 'pendente',
            }),
          );

          if (responseDoacao.statusCode == 201) {
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(
                content: Text('Doação cadastrada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(this.context);
            });
          } else {
            print('Erro roupa 1: ${responseRoupa.body}');

            throw Exception('Erro ao registrar doação');
          }
        } else {
          print('Erro roupa 2: ${responseRoupa.body}');

          throw Exception('Erro ao registrar roupa');
        }
      } catch (e) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image picker
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child:
                                        _imageFile != null
                                            ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.file(
                                                _imageFile!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                            : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: 48,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Adicionar foto',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Title field
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Nome da peça',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.label),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, informe o nome da peça';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _title =
                                        value!; // ou crie uma nova variável _name
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Category dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Categoria',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.category),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  value: _category,
                                  items:
                                      _categories.map((category) {
                                        return DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _category = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Size field
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Tamanho',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.straighten),
                                    hintText: 'Ex: P, M, G, 38, 42',
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, informe o tamanho';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _size = value!;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Description field
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Descrição',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.description),
                                    alignLabelWithHint: true,
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  maxLines: 4,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, informe uma descrição';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _description = value!;
                                  },
                                ),
                                const SizedBox(height: 30),

                                // Submit button
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2196F3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'CADASTRAR DOAÇÃO',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
            'Cadastrar Doação',
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
