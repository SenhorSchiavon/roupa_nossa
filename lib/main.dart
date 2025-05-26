import 'package:flutter/material.dart';
import 'package:roupa_nossa/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ⬅️ garante que o Flutter esteja pronto

  await dotenv.load(); // ⬅️ carrega o .env

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: App()));
}
