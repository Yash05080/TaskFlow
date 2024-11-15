import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corporate_manager/Pages/freelancing%20board/widgets/Posts.dart';
import 'package:corporate_manager/providors/freelancingpageprovider.dart';
import 'package:corporate_manager/providors/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Freelancingboard extends StatelessWidget {
  const Freelancingboard({super.key});

  @override
  Widget build(BuildContext context) {
    final freelanceProvider = Provider.of<FreelanceBoardProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collab Space",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            // This ensures the bottom sheet closes only if it's open and user scrolls down
            if (freelanceProvider.isBottomSheetOpen && details.delta.dy > 0) {
              freelanceProvider.closeBottomSheet(); // Close bottom sheet
            }
          },
          child: Column(
            children: [
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
                          final post = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              freelanceProvider.openBottomSheet(
                                  context, post); // Correct usage
                            },
                            child: PostSection(
                              message: post['Message'],
                              user: post['UserEmail'],
                              role: post['Role'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              commentCount: post['CommentCount'] ?? 0,
                              timestamp1: post['TimeStamp'],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
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
                            controller: freelanceProvider.textController,
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
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: freelanceProvider.postMessage,
                        icon: const Icon(
                          Icons.send_sharp,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
