import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';
import 'package:corporate_manager/Pages/freelancing%20board/functions/fetchrole.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Freelancingboard extends StatefulWidget {
  const Freelancingboard({super.key});

  @override
  State<Freelancingboard> createState() => _FreelancingboardState();
}

class _FreelancingboardState extends State<Freelancingboard> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  String _userRole = "Employee";
  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    UserService userService = UserService();
    String? role = await userService.fetchUserRole();

    if (role != null) {
      setState(() {
        _userRole = role;
      });
    }
  }

//post Message
  void PostMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'Role':_userRole,
        'TimeStamp': Timestamp.now(),
        'Likes':[],
      });
      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collab Space",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            //posts

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get posts
                        final post = snapshot.data!.docs[index];
                        return PostSection(
                          message: post['Message'],
                          user: post['UserEmail'],
                          role: post['Role'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes']??[]),

                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("no post yet"));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            //textfeild

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: textController,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 101, 67, 33),
                          ),
                          cursorColor: Colors.brown,
                          decoration: InputDecoration(
                              labelText: "Post Something",
                              labelStyle: const TextStyle(
                                  fontSize: 16, color: Colors.brown),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.brown, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              floatingLabelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 101, 67, 33),
                                  fontSize: 18),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 101, 67, 33),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          PostMessage();
                        },
                        icon: const Icon(
                          Icons.send_sharp,
                          size: 30,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
