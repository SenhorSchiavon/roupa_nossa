import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final void Function(String)? onChanged;

  const SearchInput({Key? key, this.onChanged}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: widget.onChanged, // 🔥 aqui é o segredo
        decoration: InputDecoration(
          hintText: 'Buscar doações...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
