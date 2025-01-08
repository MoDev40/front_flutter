import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/structure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";

  Future<void> _login() async {
    if (_email == "" || _password == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Required Fields"),
                content: const Text("Email and Password Fields are required"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Ok"))
                ],
              ));
    }

    final url = Uri.parse("http://localhost:8000/api/auth/login");
    final response = await http.post(url,
        body: jsonEncode({'email': _email, 'password': _password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data['token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => const Structure()),
      );
    } else {
      print("Error: ${response.body}");
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Enter Your Email"),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.key),
                  hintText: "Enter Your Password"),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB9E453),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => const Signup()));
                },
                child: const Text("don't have account sign up"))
          ],
        ),
      ),
    );
  }
}