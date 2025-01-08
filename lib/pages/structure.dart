import 'package:flutter/material.dart';
import 'package:frontend/pages/addTask.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/tasks.dart';

class Structure extends StatefulWidget {
  const Structure({super.key});

  @override
  State<Structure> createState() => _StructureState();
}

class _StructureState extends State<Structure> {
  int _currentIndex = 2;
  var screens = [
    const Home(),
    const Tasks(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const AddTask()));
        },
        child: const Text("+"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Tasks",
          ),
        ],
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
