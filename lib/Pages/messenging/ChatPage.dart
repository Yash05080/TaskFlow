import 'package:corporate_manager/Pages/messenging/chatRoom.dart';
import 'package:corporate_manager/Pages/messenging/widgets/usertile.dart';
import 'package:corporate_manager/models/chat_services.dart';
import 'package:corporate_manager/providors/userprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatpageState();
}

class _ChatpageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final _currentUser = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("CHAT UP"),
      ),
      body: _buildUserList(_currentUser),
    );
  }

  Widget _buildUserList(User? currentUser) {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading users"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Map<String, dynamic>> users = snapshot.data!;
        return ListView(
          children: users
              .where((userData) => userData["email"] != currentUser?.email)
              .map((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return Usertile(
      ontap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(receiverEmail: userData["email"]),
          ),
        );
      },
      text: userData["email"],
    );
  }
}
