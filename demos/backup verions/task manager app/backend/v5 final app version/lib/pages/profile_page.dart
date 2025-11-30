import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 User info
            Text(
              "Logged in as:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? "Unknown",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // 🚪 Logout button
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context); // back to AuthGate → LoginPage
              },
            ),
            const SizedBox(height: 12),

            // 🔑 Password reset button
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text("Reset Password"),
              onPressed: () async {
                if (user?.email != null) {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: user!.email!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset email sent!")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
