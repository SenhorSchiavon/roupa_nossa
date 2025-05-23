import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  final List<String> _categories = [
    'Camisetas',
    'Calças',
    'Calçados',
    'Vestidos',
    'Outros',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Here you would typically send the data to your backend

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doação cadastrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after successful submission
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
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
                                    labelText: 'Título',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.title),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, informe um título';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _title = value!;
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
