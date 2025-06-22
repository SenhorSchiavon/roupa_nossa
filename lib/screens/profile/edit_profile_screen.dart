import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  String? _fotoUrl;
  String? _novaFotoTemp;

  bool _isLoading = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _fotoUrl = user?.photoURL;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _nameController.text = prefs.getString('nome') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _cepController.text = prefs.getString('cep') ?? '';
      _cidadeController.text = prefs.getString('cidade') ?? '';
      _estadoController.text = prefs.getString('estado') ?? '';
      _enderecoController.text = prefs.getString('endereco') ?? '';
      _numeroController.text = prefs.getString('numero') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 1));

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nome', _nameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('cep', _cepController.text);
        await prefs.setString('cidade', _cidadeController.text);
        await prefs.setString('estado', _estadoController.text);
        await prefs.setString('endereco', _enderecoController.text);
        await prefs.setString('numero', _numeroController.text);

        if (_passwordController.text.isNotEmpty) {
          // Update password logic would go here
        }
        if (_novaFotoTemp != null) {
          await user?.updatePhotoURL(_novaFotoTemp);
          await FirebaseAuth.instance.currentUser?.reload();

          final response = await HttpClient().putUrl(
            Uri.parse(
              '${dotenv.env['URL_BACKEND']}/api/usuario/firebase/${user?.uid}',
            ),
          );
          response.headers.contentType = ContentType.json;
          response.write(jsonEncode({'imageUrl': _novaFotoTemp}));
          final resultado = await response.close();

          if (resultado.statusCode != 200) {
            throw Exception('Erro ao atualizar imagem no servidor');
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selecionarNovaFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${user.uid}.jpg');

        await storageRef.putFile(File(pickedFile.path));
        final downloadUrl = await storageRef.getDownloadURL();

        if (!mounted) return;
        setState(() {
          _novaFotoTemp = downloadUrl;
          _fotoUrl = downloadUrl; // já atualiza visualmente
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildProfilePicture(),
                                        const SizedBox(height: 24),

                                        // Name field
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Nome',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.person,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, informe seu nome';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Email field
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: const Icon(Icons.email),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, informe seu email';
                                            }
                                            if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                            ).hasMatch(value)) {
                                              return 'Por favor, informe um email válido';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _cepController,
                                          decoration: _inputDecoration(
                                            'CEP',
                                            Icons.location_on,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _cidadeController,
                                          decoration: _inputDecoration(
                                            'Cidade',
                                            Icons.location_city,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _estadoController,
                                          decoration: _inputDecoration(
                                            'Estado',
                                            Icons.map,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _enderecoController,
                                          decoration: _inputDecoration(
                                            'Endereço',
                                            Icons.home,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _numeroController,
                                          decoration: _inputDecoration(
                                            'Número',
                                            Icons.confirmation_number,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Password field
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: 'Nova Senha',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: const Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            helperText:
                                                'Deixe em branco para manter a senha atual',
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isNotEmpty &&
                                                value.length < 6) {
                                              return 'A senha deve ter pelo menos 6 caracteres';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Confirm password field
                                        TextFormField(
                                          controller:
                                              _confirmPasswordController,
                                          obscureText: _obscureConfirmPassword,
                                          decoration: InputDecoration(
                                            labelText: 'Confirmar Nova Senha',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.lock_outline,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureConfirmPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureConfirmPassword =
                                                      !_obscureConfirmPassword;
                                                });
                                              },
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                          ),
                                          validator: (value) {
                                            if (_passwordController
                                                .text
                                                .isNotEmpty) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Por favor, confirme sua nova senha';
                                              }
                                              if (value !=
                                                  _passwordController.text) {
                                                return 'As senhas não coincidem';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 30),

                                        // Save button
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,
                                          child: ElevatedButton(
                                            onPressed: _saveProfile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2196F3,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: const Text(
                                              'SALVAR ALTERAÇÕES',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            'Editar Perfil',
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

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _selecionarNovaFoto,
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  (_fotoUrl ?? '').isNotEmpty
                      ? NetworkImage(_fotoUrl!)
                      : const NetworkImage(
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
