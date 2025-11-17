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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // back to Homepage
        ),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text("User Info"),
            subtitle: Text("Login/Register coming soon..."),
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (value) => onToggleTheme(value), // global toggle
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            subtitle: Text("English (default)"),
          ),
        ],
      ),
    );
  }
}
