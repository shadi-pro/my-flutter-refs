import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme/theme_bloc.dart'; // Add this import

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key}); // Remove theme parameters

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final isDarkMode = themeBloc.state.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Info"),
            subtitle: Text(
              FirebaseAuth.instance.currentUser?.email ?? "Not logged in",
            ),
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode,
            activeColor: scheme.secondary,
            onChanged: (value) {
              themeBloc.add(ThemeChanged(value)); // Dispatch BLOC event
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
