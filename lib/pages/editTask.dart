import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

class EditTask extends StatefulWidget {
  final String id;
  final String initialTitle;
  final DateTime initialDueDate;
  final VoidCallback fetchTasks;

  const EditTask({
    super.key,
    required this.id,
    required this.initialTitle,
    required this.initialDueDate,
    required this.fetchTasks,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _titleController;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _dueDate = widget.initialDueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _pickDueDate() async {
    DateTime? datePick = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: _dueDate,
    );

    if (datePick != null) {
      setState(() {
        _dueDate = datePick;
      });
    }
  }

  void updateTask() async {
    var token = await Utils.token;
    final url = Uri.parse("http://localhost:8000/api/tasks/edit/${widget.id}");
    final res = await http.put(
      url,
      body: jsonEncode({
        'title': _titleController.text,
        'due': _dueDate.toString().split(' ')[0]
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (res.statusCode == 200) {
      Navigator.pop(context);
      widget.fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: _titleController,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: _pickDueDate,
              child: Text("Date: ${_dueDate.toString().split(' ')[0]}"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: updateTask,
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
