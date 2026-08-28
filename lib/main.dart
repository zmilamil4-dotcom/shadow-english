import 'package:flutter/material.dart';

void main() {
  runApp(const ShadowEnglishApp());
}

class ShadowEnglishApp extends StatelessWidget {
  const ShadowEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow English',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Shadow English\nStage 0 OK ✅',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
