import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // 🔹 Generate profile posts
  List<Map<String, dynamic>> _generateProfilePosts() {
    return [
      {
        'username': 'Shadi',
        'avatarUrl': 'https://i.pravatar.cc/150?img=8',
        'text': 'Just launched my new Flutter social media app! 🚀',
        'imageUrl': 'https://picsum.photos/400/300?random=10',
        'likes': 89,
        'comments': 24,
      },
      {
        'username': 'Shadi',
        'avatarUrl': 'https://i.pravatar.cc/150?img=8',
        'text': 'UI milestone achieved! The feed page now has pull-to-refresh.',
        'imageUrl': null,
        'likes': 56,
        'comments': 18,
      },
      {
        'username': 'Shadi',
        'avatarUrl': 'https://i.pravatar.cc/150?img=8',
        'text': null,
        'imageUrl': 'https://picsum.photos/400/350?random=11',
        'likes': 127,
        'comments': 42,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final posts = _generateProfilePosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings screen (mock)')),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Simple profile header (no import needed)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=8',
                    ),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Shadi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Flutter Developer • Tech Enthusiast',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(count: 342, label: 'Followers'),
                      _buildStatItem(count: 156, label: 'Following'),
                      _buildStatItem(count: posts.length, label: 'Posts'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // 🔹 User's posts
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: PostCard(
                    username: post['username'] as String,
                    avatarUrl: post['avatarUrl'] as String,
                    text: post['text'] as String?,
                    imageUrl: post['imageUrl'] as String?,
                    likes: post['likes'] as int,
                    comments: post['comments'] as int,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required int count, required String label}) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
