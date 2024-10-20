import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}





// use sub collection comments in the collection user posts






class _CommentsState extends State<Comments> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: Colors.white,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 140,
              child: Container(
                height: 4,
                width: 130,
                color: Colors.black,
              ),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 101, 67, 33),
                          ),
                          cursorColor: Colors.brown,
                          decoration: InputDecoration(
                              hintText: "Add a comment",
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.brown),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.brown, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              
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
      ),
    );
  }
}
