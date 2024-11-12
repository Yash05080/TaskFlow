import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
  final String role;
  final void Function()? ontap;
  const Usertile(
      {super.key, required this.ontap, required this.text, required this.role});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10), // Larger padding for a substantial look
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
          mainAxisSize: MainAxisSize.min, // Allow Row to wrap content
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize:
                  MainAxisSize.min, // Wrap content within inner Row too
              children: [
                Icon(Icons.person,
                    color: Colors.blueGrey,
                    size: 32), // Larger icon for presence
                const SizedBox(width: 16), // Spacing between icon and text
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[800],
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handle long text gracefully
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8), // Space between text and role
            Text(role),
          ],
        ),
      ),
    );
  }
}
