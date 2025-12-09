import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../models/post.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy posts for now
    final posts = [
      {
        'username': 'Shadi',
        'avatar': 'https://via.placeholder.com/150',
        'text': 'Just finished building my ExpenseTracker app 🎉',
        'image': null,
        'likes': 12,
        'comments': 3,
      },
      {
        'username': 'TechFriend',
        'avatar': 'https://via.placeholder.com/150',
        'text': 'Flutter makes UI so smooth!',
        'image': 'https://picsum.photos/400/200',
        'likes': 25,
        'comments': 5,
      },
      {
        'username': 'DesignerX',
        'avatar': 'https://via.placeholder.com/150',
        'text': null,
        'image': 'https://picsum.photos/400/300',
        'likes': 40,
        'comments': 10,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
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
    );
  }
}
