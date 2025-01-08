import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/Profile.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  late Profile profile;
  bool isLoading = true;

  Future<void> userData() async {
    try {
      final token = await Utils.token;
      final res = await http.get(
        Uri.parse("http://localhost:8000/api/auth"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          profile = Profile.fromJson(data);
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(profile.name.toUpperCase()),
          const SizedBox(height: 10),
          Text(profile.email),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextButton(
              onPressed: () async {
                await Utils.clearToken;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const Login(),
                    ),
                    (route) => false);
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Text("Logout"),
            ),
          )
        ],
      ),
    );
  }
}
