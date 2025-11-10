// [conact] => a custom widget as a page to be imported from  antother files

// provided navigator buttons  by different methods    :
//  navigate to  [ Home  page widget]  => using the {.push()} navigator method
//  navigate to  [ About  page widget]  => using the {.pushReplacement()} navigator method
//  navigate to  [ Go back  ]  => using the {.pop()}  navigator method
//  ------------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This is the Contact Page",
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Returned Home using pushNamedAndRemoveUntil()',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Go to Home (clear stack)'),
            ),
          ],
        ),
      ),
    );
  }
}
