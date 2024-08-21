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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Collab Space",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                //posts
                SizedBox(height: 20,),
            
                //textfeild
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              borderSide:
                                  const BorderSide(color: Colors.brown, width: 2),
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
                            )
                              
                            ),
                            
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_up))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
