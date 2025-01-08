import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/structure.dart';
import 'package:frontend/utils.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await Utils.token;
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => const Structure()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
