import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
  final void Function()? ontap;
  const Usertile({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24), // Larger padding for a substantial look
        margin: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 16), // Consistent margin for spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12), // Softer, larger radius for elegance
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 12,
              offset:
                  Offset(0, 6), // Deeper shadow for a stronger pop-out effect
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.person,
                color: Colors.blueGrey, size: 32), // Larger icon for presence
            const SizedBox(width: 16), // Spacing between icon and text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis, // Handle long text gracefully
              ),
            ),
          ],
        ),
      ),
    );
  }
}
