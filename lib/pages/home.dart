import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/Task.dart';
import 'package:frontend/pages/deleteTask.dart';
import 'package:frontend/pages/editTask.dart';
import 'package:frontend/pages/isDone.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  bool isLoading = true;

  Future<void> fetchTasks() async {
    try {
      var token = await Utils.token;

      var res = await http.get(
        Uri.parse("http://localhost:8000/api/tasks/top"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (res.statusCode == 200) {
        var jsonTasks = json.decode(res.body);
        setState(() {
          tasks = jsonTasks.map<Task>((data) => Task.fromJson(data)).toList();
          isLoading = false; // Set loading to false after fetching
        });
      } else {
        throw Exception("Failed to fetch tasks");
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
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available.'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index].title),
          leading: IsDone(
            id: tasks[index].id,
            fetchTasks: fetchTasks,
            isDone: tasks[index].isDone,
          ),
          trailing: DeleteTask(
            id: tasks[index].id,
            fetchTasks: fetchTasks,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => EditTask(
                  id: tasks[index].id,
                  initialTitle: tasks[index].title,
                  initialDueDate: tasks[index].due,
                  fetchTasks: fetchTasks,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
