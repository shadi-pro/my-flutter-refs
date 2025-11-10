// [about] => a custom widget as a page to be imported from  antother files
// provided with button of    navigator  to [Homepage  widget]
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This is the About Page",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Returned using Navigator.pop()'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Back (pop)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigated using Navigator.push()'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Open Contact (push)'),
            ),
          ],
        ),
      ),
    );
  }
}
