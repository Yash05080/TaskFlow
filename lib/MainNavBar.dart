import 'package:corporate_manager/Pages/HomePage/HomePage.dart';
import 'package:corporate_manager/Pages/Profile/Profilepage.dart';
import 'package:corporate_manager/Pages/freelancing%20board/freelancingboard.dart';
import 'package:corporate_manager/Pages/messenging/ChatPage.dart';
import 'package:corporate_manager/Pages/taskpage/taskpage.dart';
import 'package:corporate_manager/providors/pageprovidor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MainNavBar extends StatelessWidget {
  MainNavBar({super.key});

  final List<Widget> screens = [
    const ChatPage(),
    const TaskPage(),
    const MyDashBoard(),
    Freelancingboard(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        heroTag: 'HomeTag',
        onPressed: () {
          pageProvider.updateIndex(2); // Set default to dashboard
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
            buildNavItem(context, 0, Icons.message, "Chat"),
            buildNavItem(context, 1, Icons.check_box, "Tasks"),
            const SizedBox(width: 17), // Space for the floating action button
            buildNavItem(context, 3, Icons.add_business, "Forum"),
            buildNavItem(context, 4, Icons.person_outline, "Profile"),
          ],
        ),
      ),
      body: screens[pageProvider.selectedIndex],
    );
  }

  Widget buildNavItem(
      BuildContext context, int index, IconData icon, String label) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    final isSelected = pageProvider.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        pageProvider.updateIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? HexColor("0b1623") : Colors.grey.shade400,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? HexColor("0b1623") : Colors.grey.shade400,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
