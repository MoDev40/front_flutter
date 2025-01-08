import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String _title = "";
  DateTime _dueDate = DateTime.now();

  void _pickDueDate() async {
    DateTime? datePick = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (datePick != null) {
      setState(() {
        _dueDate = datePick;
      });
    }
  }

  void updateTask() async {
    var token = await Utils.token;
    final url = Uri.parse("http://localhost:8000/api/tasks/create");
    final res = await http.post(
      url,
      body: jsonEncode(
          {'title': _title, 'due': _dueDate.toString().split(' ')[0]}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (res.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: _pickDueDate,
              child: Text("Date: ${_dueDate.toString().split(' ')[0]}"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: updateTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
