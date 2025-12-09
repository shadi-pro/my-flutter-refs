import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String? text;
  final String? imageUrl;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.username,
    required this.avatarUrl,
    this.text,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header (avatar + username)
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Text content
            if (text != null) Text(text!, style: const TextStyle(fontSize: 14)),

            // 🔹 Image content
            if (imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl!),
              ),
            ],

            const SizedBox(height: 10),

            // 🔹 Action row (likes + comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red.shade400),
                    const SizedBox(width: 4),
                    Text('$likes'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text('$comments'),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shared post!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
