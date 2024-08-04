import 'package:corporate_manager/Pages/HomePage/HomePage.dart';
import 'package:corporate_manager/Pages/Profile/Profilepage.dart';
import 'package:corporate_manager/Pages/freelancing%20board/freelancingboard.dart';
import 'package:corporate_manager/Pages/messenging/ChatPage.dart';
import 'package:corporate_manager/Pages/taskpage/taskpage.dart';
import 'package:flutter/material.dart';

class MainNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavBar> {
  int currentIndex = 2;
  List screens = [
    ChatPage(),
    TaskPage(),
    MyHomePage(),
    Freelancingboard(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
        shape: CircleBorder(),
        splashColor: Colors.blue,
        hoverColor: Colors.lightBlue,
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.home,
          color: Colors.white,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        height: 60,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.message,
                  size: 32,
                  color:
                      currentIndex == 0 ? Colors.indigo : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.check_box,
                  size: 32,
                  color:
                      currentIndex == 1 ? Colors.indigo : Colors.grey.shade400,
                )),
            SizedBox(
              width: 17,
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.add_business,
                  size: 32,
                  color:
                      currentIndex == 3 ? Colors.indigo : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 4;
                  });
                },
                icon: Icon(
                  Icons.person_outline,
                  size: 32,
                  color:
                      currentIndex == 4 ? Colors.indigo : Colors.grey.shade400,
                )),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
