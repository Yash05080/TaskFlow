import 'dart:ffi';

import 'package:flutter/material.dart';

class Deletebutton extends StatelessWidget {
  final VoidCallback onTap;

  const Deletebutton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.brown),
      onPressed: onTap,
    );
  }
}
