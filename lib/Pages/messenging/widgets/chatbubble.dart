import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  final String message;
  final bool iscurrentuser;

  const Chatbubble(
      {super.key, required this.iscurrentuser, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      //margin: EdgeInsets.symmetric(vertical: , horizontal: 10),
      decoration: BoxDecoration(
          color: iscurrentuser ? Colors.brown[700] : Colors.brown[400],
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        message,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
      ),
    );
  }
}
