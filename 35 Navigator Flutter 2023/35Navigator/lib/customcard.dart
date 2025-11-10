import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final String name;
  final String email;
  final String date;
  final String imagename;

  const CustomListtile({
    super.key,
    required this.name,
    required this.email,
    required this.date,
    required this.imagename,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade100,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                imagename,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
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
