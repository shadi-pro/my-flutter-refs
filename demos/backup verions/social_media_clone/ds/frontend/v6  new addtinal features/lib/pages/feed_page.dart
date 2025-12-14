import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/post_card.dart';
import '../core/providers/post_provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isRefreshing = false;

  Future<void> _refreshPosts() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: posts.length + 1, // +1 for empty state or header
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader(postProvider);
            }

            if (posts.isEmpty) {
              return _buildEmptyState();
            }

            final postIndex = index - 1;
            if (postIndex >= posts.length) return null;

            final post = posts[postIndex];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PostCard(
                username: post['username'] as String,
                postId: post['id'] as String,
                avatarUrl: post['avatarUrl'] as String,
                text: post['text'] as String?,
                imageUrl: post['imageUrl'] as String?,
                likes: post['likes'] as int,
                comments: post['comments'] as int,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(PostProvider postProvider) {
    return Column(
      children: [
        // Stats header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.newspaper, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'Latest Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text('${postProvider.posts.length} posts'),
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(Icons.post_add, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Be the first to share something! Tap the + button to create a post.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to Add Post page
              // You'll need navigation logic here
            },
            icon: const Icon(Icons.add),
            label: const Text('Create First Post'),
          ),
        ],
      ),
    );
  }
}
