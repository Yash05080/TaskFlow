import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PointsTile extends StatelessWidget {
  final int totalPoints;

  const PointsTile({required this.totalPoints, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 46, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: HexColor("f4c430"),
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              'Total Points: $totalPoints',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: HexColor("0b1623"),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
