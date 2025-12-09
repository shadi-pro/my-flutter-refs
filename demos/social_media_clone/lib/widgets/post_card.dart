import 'package:flutter/material.dart';

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
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header (avatar + username)
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
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
            if (text != null && text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(text!, style: const TextStyle(fontSize: 14)),
              ),

            // 🔹 Image placeholder (NO NETWORK IMAGE)
            if (imageUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Image Placeholder'),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // 🔹 Action row (likes + comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Likes
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Liked!')));
                      },
                    ),
                    Text('$likes'),
                  ],
                ),

                // Comments
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.comment_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Open comments')),
                        );
                      },
                    ),
                    Text('$comments'),
                  ],
                ),

                // Share
                IconButton(
                  icon: Icon(Icons.share_outlined, color: Colors.grey[600]),
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Shared!')));
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
