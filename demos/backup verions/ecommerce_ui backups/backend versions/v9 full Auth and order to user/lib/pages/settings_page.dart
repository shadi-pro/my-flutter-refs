import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const SettingsPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        // Navigation handled by BottomNav, no back arrow
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Info"),
            subtitle: const Text("Login/Register with Firebase Auth"),
            onTap: () {
              // 🔜 Future: Navigate to profile page or Firebase Auth screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User info coming soon")),
              );
            },
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode,
            activeColor: scheme.secondary,
            onChanged: (value) => onToggleTheme(value),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("English (default)"),
            onTap: () {
              // 🔜 Future: Add language selection dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Language settings coming soon")),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // 🔜 Future: Firebase Auth signOut()
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout not yet implemented")),
              );
            },
          ),
        ],
      ),
    );
  }
}
