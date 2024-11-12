import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/messenging/widgets/chatbubble.dart';
import 'package:corporate_manager/models/chat_services.dart';
import 'package:corporate_manager/providors/userprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatRoom({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initial scroll to the bottom with delay
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 300));
      scrollDown();
    });

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            scrollDown();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          scrollDown();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final _currentUser = userProvider.currentUser;

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.receiverEmail)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // Message list section with a slight delay
          Expanded(child: _buildMessageList(_currentUser.uid, _currentUser)),
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList(String senderID, User? currentuser) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error loading your chat");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox()); // Removes loading circle
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet."));
        }

        // Scroll to the latest message when data is loaded, with delay
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 300));
          if (_scrollController.hasClients) {
            scrollDown();
          }
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc, currentuser))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, User? currentuser) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (!data.containsKey("message")) return const SizedBox();
    bool iscurrentUser = data['senderID'] == currentuser!.uid;
    var alignment =
        iscurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            iscurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Chatbubble(
              iscurrentuser: iscurrentUser,
              message: data["message"],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 40 : 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown[100],
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: myFocusNode,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.brown[800], fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.send, color: Colors.brown[800], size: 35),
            ),
          ],
        ),
      ),
    );
  }
}
