import 'dart:ffi';

import 'package:flutter/material.dart';

class Deletebutton extends StatelessWidget {
  final void Function()? onTap;
  const Deletebutton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.delete),
    );
  }
}