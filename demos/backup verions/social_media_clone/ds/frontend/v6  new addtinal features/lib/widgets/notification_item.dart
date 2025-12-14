import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onToggleRead;
  final VoidCallback? onFollowBack;
  final VoidCallback? onViewPost;
  final VoidCallback? onLikeComment;
  final bool showActions;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onToggleRead,
    this.onFollowBack,
    this.onViewPost,
    this.onLikeComment,
    this.showActions = true,
  });

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'follow':
        return Icons.person_add;
      case 'mention':
        return Icons.alternate_email;
      case 'share':
        return Icons.share;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.blue;
      case 'follow':
        return Colors.green;
      case 'mention':
        return Colors.purple;
      case 'share':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getNotificationIcon(notification['type']);
    final color = _getNotificationColor(notification['type']);
    final timeAgo = _formatTimeAgo(notification['time']);

    return Card(
      elevation: notification['isUnread'] ? 2 : 1,
      color: notification['isUnread'] ? Colors.blue[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon with unread indicator
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (notification['isUnread'])
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info and time
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 12,
                        child: Text(
                          notification['userAvatar'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification['userName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Notification message
                  _buildNotificationMessage(),

                  const SizedBox(height: 12),

                  // Action buttons (conditionally shown)
                  if (showActions) _buildActionButtons(),
                ],
              ),
            ),

            // Mark as read button
            IconButton(
              icon: Icon(
                notification['isUnread']
                    ? Icons.mark_chat_unread
                    : Icons.mark_chat_read,
                size: 20,
                color: notification['isUnread'] ? Colors.blue : Colors.grey,
              ),
              onPressed: onToggleRead,
              tooltip: notification['isUnread']
                  ? 'Mark as read'
                  : 'Mark as unread',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationMessage() {
    switch (notification['type']) {
      case 'like':
        return Text('liked your post: "${notification['postPreview']}"');

      case 'comment':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('commented on your post: "${notification['postPreview']}"'),
            const SizedBox(height: 4),
            if (notification['commentText'] != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${notification['commentText']}"',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        );

      case 'follow':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('started following you'),
            if (notification['bio'] != null) ...[
              const SizedBox(height: 4),
              Text(
                notification['bio'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        );

      case 'mention':
        return Text(
          'mentioned you in a post: "${notification['postPreview']}"',
        );

      case 'share':
        return Text('shared your post: "${notification['postPreview']}"');

      default:
        return const Text('sent you a notification');
    }
  }

  Widget _buildActionButtons() {
    final actions = <Widget>[];

    // Follow back button for follow notifications
    if (notification['type'] == 'follow' &&
        !notification['isFollowing'] &&
        onFollowBack != null) {
      actions.add(
        ElevatedButton(
          onPressed: onFollowBack,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Follow Back'),
        ),
      );
    }

    // View post button for post-related notifications
    if ([
          'like',
          'comment',
          'mention',
          'share',
        ].contains(notification['type']) &&
        onViewPost != null) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 8));
      }
      actions.add(
        OutlinedButton(
          onPressed: onViewPost,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('View Post'),
        ),
      );
    }

    // Like/Comment buttons for comment notifications
    if (notification['type'] == 'comment' && onLikeComment != null) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 8));
      }
      actions.add(
        OutlinedButton.icon(
          onPressed: onLikeComment,
          icon: const Icon(Icons.favorite_border, size: 16),
          label: const Text('Like'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(spacing: 8, runSpacing: 8, children: actions);
  }
}
