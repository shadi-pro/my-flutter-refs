import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/post_provider.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String postId;
  final String avatarUrl;
  final String? text;
  final String? imageUrl;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.username,
    required this.postId,
    required this.avatarUrl,
    this.text,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  int _currentLikes = 0;
  bool _showComments = false;
  List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.likes;
    // Generate some mock comments
    _comments = ['Great post!', 'Love this!', 'Awesome work 👏', 'Well said!'];
  }

  void _toggleLike() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.likePost(
      widget.postId,
    ); // You'll need to add postId to PostCard

    setState(() {
      _isLiked = !_isLiked;
      _currentLikes += _isLiked ? 1 : -1;
    });
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  void _addComment(String comment) {
    if (comment.trim().isNotEmpty) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.addComment(widget.postId); // Add to provider

      setState(() {
        _comments.add(comment);
      });
    }
  }

  void _sharePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Post'),
        content: const Text('Choose how to share this post:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post shared to feed')),
              );
            },
            child: const Text('Share to Feed'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Post link copied')));
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Save Post'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Post saved')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: const Text('Mute Notifications'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications muted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Post reported')));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

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
            // 🔹 Header (avatar + username + options)
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    widget.username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: _showOptions,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Text content
            if (widget.text != null && widget.text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(widget.text!, style: const TextStyle(fontSize: 14)),
              ),

            // 🔹 Image placeholder
            if (widget.imageUrl != null)
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

            // 🔹 Stats (likes & comments count)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text('$_currentLikes'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Icon(Icons.comment, size: 16, color: Colors.blue[400]),
                      const SizedBox(width: 4),
                      Text('${widget.comments}'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 20),

            // 🔹 Action buttons (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Like Button
                Expanded(
                  child: TextButton.icon(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    label: Text(
                      _isLiked ? 'Liked' : 'Like',
                      style: TextStyle(
                        color: _isLiked ? Colors.red : Colors.grey[700],
                      ),
                    ),
                    style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  ),
                ),

                // Comment Button
                Expanded(
                  child: TextButton.icon(
                    onPressed: _toggleComments,
                    icon: Icon(
                      Icons.comment_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    label: Text(
                      _showComments ? 'Comments' : 'Comment',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  ),
                ),

                // Share Button
                Expanded(
                  child: TextButton.icon(
                    onPressed: _sharePost,
                    icon: Icon(
                      Icons.share_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    label: Text(
                      'Share',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  ),
                ),
              ],
            ),

            // 🔹 Comments Section (expandable)
            if (_showComments) ...[
              const Divider(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Comments List
                    ..._comments
                        .map(
                          (comment) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(comment),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),

                    const SizedBox(height: 12),

                    // Add Comment Input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (value) {
                              _addComment(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              size: 16,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // In real app, get text from controller
                              _addComment('New comment');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
