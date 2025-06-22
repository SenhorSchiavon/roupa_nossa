import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roupa_nossa/commons/routes.dart';
import 'package:roupa_nossa/screens/welcome/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:roupa_nossa/services/cep/cepService.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  String? _sexoSelecionado;

  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Future<void> registrarUsuario(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['URL_BACKEND']}/api/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nome": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "senha": _passwordController.text.trim(),
          "cep": _cepController.text.trim(),
          "endereco": _enderecoController.text.trim(),
          "numero": _numeroController.text.trim(),
          "cidade": _cidadeController.text.trim(),
          "estado": _estadoController.text.trim(),
        }),
      );

      print('RESPOSTA [register]: ${response.statusCode} → ${response.body}');
      final data = json.decode(response.body);
      print('DATA: $data (${data.runtimeType})');
      print('✅ Status: ${response.statusCode}');
      print('✅ Success: ${data['success']}');

      if (response.statusCode == 201 && data['success'] == true) {
        final user = data['user'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('id', user['id'] as int);
        await prefs.setString('nome', user['nome'] as String);
        await prefs.setString('email', user['email'] as String);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (welcomeCtx) => WelcomeScreen(
                  userName: user['nome'] as String,
                  isReturningUser: false,
                  onContinue: () {
                    Navigator.pushReplacementNamed(
                      welcomeCtx,
                      NamedRoutes.main,
                    );
                  },
                ),
          ),
        );
      } else {
        final error = data['error'] as String? ?? 'Erro ao cadastrar';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        throw Exception(data['error'] ?? 'Erro ao registrar no servidor');
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'email-already-in-use') {
        errorMsg = 'E-mail já está em uso.';
      } else if (e.code == 'weak-password') {
        errorMsg = 'Senha muito fraca.';
      } else {
        errorMsg = 'Erro no Firebase Auth: ${e.message}';
      }

      showError(errorMsg);
    } catch (e) {
      print('Erro na requisição de registro: $e');
      showError('Erro ao registrar: ${e.toString()}');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    _numeroController.dispose();
    _celularController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();

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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/tshirt1.png',
                                width: 80,
                                height: 80,
                                color: const Color(0xFF2196F3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Roupa Nossa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Crie sua conta',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nome completo',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Campo de email
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _celularController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Número do Celular',
                                  prefixIcon: const Icon(
                                    Icons.phone_iphone_rounded,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _cepController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'CEP',
                                  prefixIcon: Icon(Icons.location_on),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (value) async {
                                  final cep = value.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );
                                  if (cep.length == 8) {
                                    final endereco = await buscarCep(cep);

                                    if (endereco != null) {
                                      setState(() {
                                        _enderecoController.text =
                                            '${endereco['logradouro']}, ${endereco['bairro']}';
                                        _cidadeController.text =
                                            endereco['localidade'] ?? '';
                                        _estadoController.text =
                                            endereco['uf'] ?? '';
                                      });
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('CEP não encontrado'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 16),
                              TextField(
                                controller: _enderecoController,
                                decoration: InputDecoration(
                                  labelText: 'Endereço',
                                  prefixIcon: const Icon(Icons.home),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _numeroController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Número',
                                  prefixIcon: Icon(Icons.home),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _cidadeController,
                                decoration: InputDecoration(
                                  labelText: 'Cidade',
                                  prefixIcon: const Icon(Icons.location_city),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _estadoController,
                                decoration: InputDecoration(
                                  labelText: 'Estado',
                                  prefixIcon: const Icon(Icons.map),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => registrarUsuario(context),

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2196F3),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),

                                  child: Text(
                                    'CADASTRAR',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _socialButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(child: Image.asset(icon, width: 30, height: 30)),
      ),
    );
  }
}
