import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String email;
  final String date;
  final String imageName;

  const CustomCard({
    super.key,
    required this.name,
    required this.email,
    required this.date,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue.shade50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                imageName,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ListTile(
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(email),
                trailing: Text(date),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
