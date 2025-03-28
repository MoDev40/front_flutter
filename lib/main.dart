import 'package:flutter/material.dart';
import 'package:frontend/pages/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Task Manager Application",
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
