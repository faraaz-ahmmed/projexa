import 'package:flutter/material.dart';

void main() {
  runApp(const ProjexaApp());
}

class ProjexaApp extends StatelessWidget {
  const ProjexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Projexa')),
      ),
    );
  }
}