import 'package:corporate_manager/Pages/HomePage/HomePage.dart';
import 'package:corporate_manager/Pages/Profile/Profilepage.dart';
import 'package:corporate_manager/Pages/freelancing%20board/freelancingboard.dart';
import 'package:corporate_manager/Pages/messenging/ChatPage.dart';
import 'package:corporate_manager/Pages/taskpage/taskpage.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MainNavBar> {
  int currentIndex = 2;
  List screens = [
    const ChatPage(),
    const TaskPage(),
    const MyDashBoard(),
    const Freelancingboard(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'HomeTag',
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
        shape: const CircleBorder(),
        splashColor: Colors.indigo,
        hoverColor: Colors.indigoAccent,
        backgroundColor: HexColor("0b1623"),
        child: const Icon(
          Icons.home,
          color: Colors.white,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        height: 85, // Increased height to accommodate labels
        color: HexColor("f1e0d0"),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavItem(0, Icons.message, "Chat"),
            buildNavItem(1, Icons.check_box, "Tasks"),
            const SizedBox(width: 17), // Space for the floating action button
            buildNavItem(3, Icons.add_business, "Freelance"),
            buildNavItem(4, Icons.person_outline, "Profile"),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }

  Widget buildNavItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: currentIndex == index
                  ? HexColor("0b1623")
                  : Colors.grey.shade400,
            ),
            Text(
              label,
              style: TextStyle(
                  color: currentIndex == index
                      ? HexColor("0b1623")
                      : Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
