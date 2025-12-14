import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];

  // Sample initial posts
  List<Map<String, dynamic>> get posts => _posts;

  PostProvider() {
    // Initialize with sample posts
    _posts = _getInitialPosts();
  }

  List<Map<String, dynamic>> _getInitialPosts() {
    return [
      {
        'id': '1',
        'username': 'Shadi',
        'avatarUrl': 'S',
        'text':
            'Just finished building my ExpenseTracker app 🎉 #Flutter #Dart',
        'imageUrl': null,
        'likes': 12,
        'comments': 3,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'username': 'TechFriend',
        'avatarUrl': 'T',
        'text':
            'Flutter makes UI so smooth! Building beautiful interfaces has never been easier.',
        'imageUrl': null,
        'likes': 25,
        'comments': 5,
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'id': '3',
        'username': 'DesignerX',
        'avatarUrl': 'D',
        'text': null,
        'imageUrl': null,
        'likes': 40,
        'comments': 10,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }

  // Add a new post
  void addPost({required String text, String? imageUrl}) {
    final newPost = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'username': 'You', // Current user
      'avatarUrl': 'Y',
      'text': text,
      'imageUrl': imageUrl,
      'likes': 0,
      'comments': 0,
      'timestamp': DateTime.now(),
    };

    _posts.insert(0, newPost); // Add to beginning
    notifyListeners();
  }

  // Like a post
  void likePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post['id'] == postId);
    if (postIndex != -1) {
      _posts[postIndex]['likes'] = (_posts[postIndex]['likes'] as int) + 1;
      notifyListeners();
    }
  }

  // Add a comment to a post
  void addComment(String postId) {
    final postIndex = _posts.indexWhere((post) => post['id'] == postId);
    if (postIndex != -1) {
      _posts[postIndex]['comments'] =
          (_posts[postIndex]['comments'] as int) + 1;
      notifyListeners();
    }
  }

  // Delete a post (for demo purposes)
  void deletePost(String postId) {
    _posts.removeWhere((post) => post['id'] == postId);
    notifyListeners();
  }

  // Clear all posts (for testing)
  void clearPosts() {
    _posts.clear();
    _posts = _getInitialPosts();
    notifyListeners();
  }
}
