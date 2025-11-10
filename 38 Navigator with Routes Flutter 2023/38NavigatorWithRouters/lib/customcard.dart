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
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(imagename, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ListTile(
                title: Text(name),
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
