class Post {
  final String username;
  final String avatarUrl;
  final String? text;
  final String? imageUrl;
  final int likes;
  final int comments;

  Post({
    required this.username,
    required this.avatarUrl,
    this.text,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  // 🔹 Factory constructor for dummy data or Firestore later
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      username: map['username'] as String,
      avatarUrl: map['avatar'] as String,
      text: map['text'] as String?,
      imageUrl: map['image'] as String?,
      likes: map['likes'] as int,
      comments: map['comments'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'avatar': avatarUrl,
      'text': text,
      'image': imageUrl,
      'likes': likes,
      'comments': comments,
    };
  }
}
