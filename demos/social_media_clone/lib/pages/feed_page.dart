import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  // 🔹 Generate mock posts matching PostCard parameters
  List<Map<String, dynamic>> _generateMockPosts() {
    return [
      {
        'username': 'Shadi',
        'avatarUrl': 'https://i.pravatar.cc/150?img=1',
        'text':
            'Just finished building my ExpenseTracker app 🎉 #Flutter #Dart',
        'imageUrl': null,
        'likes': 12,
        'comments': 3,
      },
      {
        'username': 'TechFriend',
        'avatarUrl': 'https://i.pravatar.cc/150?img=5',
        'text':
            'Flutter makes UI so smooth! Building beautiful interfaces has never been easier.',
        'imageUrl': 'https://picsum.photos/400/250?random=1',
        'likes': 25,
        'comments': 5,
      },
      {
        'username': 'DesignerX',
        'avatarUrl': 'https://i.pravatar.cc/150?img=9',
        'text':
            'Exploring new design patterns in Flutter. The possibilities are endless!',
        'imageUrl': 'https://picsum.photos/400/300?random=2',
        'likes': 40,
        'comments': 10,
      },
      {
        'username': 'CodeMaster',
        'avatarUrl': 'https://i.pravatar.cc/150?img=12',
        'text':
            'Just published my new package on pub.dev! Check it out if you need state management helpers.',
        'imageUrl': null,
        'likes': 87,
        'comments': 23,
      },
      {
        'username': 'UI_Artist',
        'avatarUrl': 'https://i.pravatar.cc/150?img=15',
        'text': null,
        'imageUrl': 'https://picsum.photos/400/350?random=3',
        'likes': 120,
        'comments': 42,
      },
      {
        'username': 'MobileDev',
        'avatarUrl': 'https://i.pravatar.cc/150?img=20',
        'text':
            'Working on a new social media app UI in Flutter. Any feature suggestions?',
        'imageUrl': null,
        'likes': 56,
        'comments': 18,
      },
      {
        'username': 'OpenSource',
        'avatarUrl': 'https://i.pravatar.cc/150?img=25',
        'text':
            'Contributed to a Flutter open source project today! Always great to give back to the community.',
        'imageUrl': 'https://picsum.photos/400/200?random=4',
        'likes': 92,
        'comments': 31,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final posts = _generateMockPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Mock refresh action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feed refreshed (mock)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Refresh feed',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Mock refresh with delay
          await Future.delayed(const Duration(seconds: 1));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feed updated with new posts'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = posts[index];

            return PostCard(
              username: post['username'] as String,
              avatarUrl: post['avatarUrl'] as String,
              text: post['text'] as String?,
              imageUrl: post['imageUrl'] as String?,
              likes: post['likes'] as int,
              comments: post['comments'] as int,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create post
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage()));

          // For now, show mock message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigate to create post screen'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Create new post',
      ),
    );
  }
}
