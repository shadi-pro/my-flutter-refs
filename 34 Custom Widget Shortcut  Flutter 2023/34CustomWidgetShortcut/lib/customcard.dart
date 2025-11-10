// customcard.dart
// ------------------------------------------
// Custom reusable widget for displaying a user card
// ------------------------------------------

import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  // 1️⃣ Define variables
  final String name;
  final String email;
  final String date;
  final String imagename;

  // 2️⃣ Constructor
  const CustomListtile({
    super.key,
    required this.name,
    required this.email,
    required this.date,
    required this.imagename,
  });

  // 3️⃣ Build method
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shadowColor: Colors.blueAccent.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // 🖼 Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                imagename,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),

            const SizedBox(width: 12),

            // 📜 Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // 📅 Date on the right
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
