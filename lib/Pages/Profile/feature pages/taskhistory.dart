import 'package:flutter/material.dart';

class Taskhistory extends StatefulWidget {
  const Taskhistory({super.key});

  @override
  State<Taskhistory> createState() => _TaskhistoryState();
}

class _TaskhistoryState extends State<Taskhistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task History"),),
    );
  }
}