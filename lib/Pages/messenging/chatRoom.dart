import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final String receiverEmail;
  const ChatRoom({super.key,required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail),),
    );
  }
}
