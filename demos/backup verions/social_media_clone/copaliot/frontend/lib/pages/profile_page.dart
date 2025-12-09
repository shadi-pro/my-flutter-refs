import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/post_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy posts for profile
    final posts = [
      {
        'username': 'Shadi',
        'avatar': 'https://via.placeholder.com/150',
        'text': 'Loving Flutter development!',
        'image': 'https://picsum.photos/400/200',
        'likes': 15,
        'comments': 2,
      },
      {
        'username': 'Shadi',
        'avatar': 'https://via.placeholder.com/150',
        'text': 'UI milestone achieved 🚀',
        'image': null,
        'likes': 8,
        'comments': 1,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(
              username: 'Shadi',
              bio: 'Flutter developer • Tech enthusiast',
              avatarUrl: 'https://via.placeholder.com/150',
              followers: 120,
              following: 80,
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  username: post['username']!,
                  avatarUrl: post['avatar']!,
                  text: post['text'],
                  imageUrl: post['image'],
                  likes: post['likes']!,
                  comments: post['comments']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
