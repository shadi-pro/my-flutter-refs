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
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey.shade300,
          ),

          const SizedBox(height: 12),

          // Username
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

          const SizedBox(height: 6),

          // Bio
          Text(
            bio,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),

          const SizedBox(height: 16),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(count: followers, label: 'Followers'),
              _buildStatItem(count: following, label: 'Following'),
            ],
          ),

          const SizedBox(height: 16),

          // Action Button
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

  Widget _buildStatItem({required int count, required String label}) {
    return Column(
      children: [
        Text(
          _formatCount(count),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
