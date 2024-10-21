import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatpageState();
}

class _ChatpageState extends State<ChatPage> {
  // Sample chat data
  final List<Message> messages = [
  Message(
    sender: 'yash05080@gmail.com',
    text: 'Hello Manager! Please update the task status.',
    isAdmin: true,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'Sure! I’ll get it done by today.',
    isAdmin: false,
  ),
  Message(
    sender: 'yash05080@gmail.com',
    text: 'Perfect, let me know if you need anything.',
    isAdmin: true,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'Thanks! Will do.',
    isAdmin: false,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'By the way, I’ve assigned the new task to the dev team.',
    isAdmin: false,
  ),
  Message(
    sender: 'yash05080@gmail.com',
    text: 'Good! Make sure it gets done before the weekend.',
    isAdmin: true,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'Noted. They’ve already started working on it.',
    isAdmin: false,
  ),
  Message(
    sender: 'yash05080@gmail.com',
    text: 'Awesome. Also, update the documentation after completion.',
    isAdmin: true,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'Will do! Anything else you’d like me to take care of?',
    isAdmin: false,
  ),
  Message(
    sender: 'yash05080@gmail.com',
    text: 'Nope, that’s all for now. Keep me posted.',
    isAdmin: true,
  ),
  Message(
    sender: 'manager@gmail.com',
    text: 'Sure! Talk to you soon.',
    isAdmin: false,
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          SizedBox(width: 10,),

          Icon(Icons.photo,color: Colors.brown,size: 30,),

          SizedBox(width: 4,),
          IconButton(
            icon: Icon(Icons.send, color: Colors.brown,size: 30,),
            onPressed: () {
              // Logic for sending a message will go here
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final bubbleColor = message.isAdmin ? Colors.brown : Colors.brown[300];
    final textColor = message.isAdmin ? Colors.white : Colors.white;
    final borderRadius = message.isAdmin
        ? BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        : BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          );

    return Align(
      alignment: message.isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final bool isAdmin;

  Message({required this.sender, required this.text, required this.isAdmin});
}
