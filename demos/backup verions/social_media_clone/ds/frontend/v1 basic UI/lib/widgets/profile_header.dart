import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String bio;
  final String avatarUrl;
  final int followers;
  final int following;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(height: 12),
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 6),
          Text(bio, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('Followers', followers),
              const SizedBox(width: 24),
              _buildStat('Following', following),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile tapped')),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label),
      ],
    );
  }
}
