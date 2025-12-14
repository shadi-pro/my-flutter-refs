import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _notifications = _generateMockNotifications();
      _unreadCount = _notifications.where((n) => n['isUnread']).length;
      _isLoading = false;
    });
  }

  void _toggleReadStatus(int index) {
    setState(() {
      _notifications[index]['isUnread'] = !_notifications[index]['isUnread'];
      _unreadCount = _notifications.where((n) => n['isUnread']).length;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isUnread'] = false;
      }
      _unreadCount = 0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _followBack(int index) {
    setState(() {
      _notifications[index]['isFollowing'] = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Followed ${_notifications[index]['userName']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockNotifications() {
    final now = DateTime.now();
    
    return [
      {
        'id': '1',
        'type': 'like',
        'userName': 'flutter_dev',
        'userAvatar': 'F',
        'postPreview': 'Your Flutter app looks amazing!',
        'time': now.subtract(const Duration(minutes: 15)),
        'isUnread': true,
        'isFollowing': false,
      },
      {
        'id': '2',
        'type': 'comment',
        'userName': 'ui_designer',
        'userAvatar': 'U',
        'postPreview': 'Great design choices in your portfolio!',
        'commentText': 'Love the color scheme and animations!',
        'time': now.subtract(const Duration(hours: 2)),
        'isUnread': true,
        'isFollowing': true,
      },
      {
        'id': '3',
        'type': 'follow',
        'userName': 'code_master',
        'userAvatar': 'C',
        'bio': 'Senior Developer • Open Source Contributor',
        'time': now.subtract(const Duration(hours: 5)),
        'isUnread': true,
        'isFollowing': false,
      },
      {
        'id': '4',
        'type': 'mention',
        'userName': 'tech_guru',
        'userAvatar': 'T',
        'postPreview': 'Check out this amazing Flutter portfolio!',
        'time': now.subtract(const Duration(days: 1)),
        'isUnread': false,
        'isFollowing': false,
      },
      {
        'id': '5',
        'type': 'share',
        'userName': 'mobile_expert',
        'userAvatar': 'M',
        'postPreview': 'Shared your post about Flutter best practices',
        'time': now.subtract(const Duration(days: 2)),
        'isUnread': false,
        'isFollowing': true,
      },
      {
        'id': '6',
        'type': 'like',
        'userName': 'design_wizard',
        'userAvatar': 'D',
        'postPreview': 'Your UI animations are smooth!',
        'time': now.subtract(const Duration(days: 3)),
        'isUnread': false,
        'isFollowing': false,
      },
      {
        'id': '7',
        'type': 'comment',
        'userName': 'app_architect',
        'userAvatar': 'A',
        'postPreview': 'Impressive architecture in your social app',
        'commentText': 'Clean code structure and good state management!',
        'time': now.subtract(const Duration(days: 5)),
        'isUnread': false,
        'isFollowing': false,
      },
      {
        'id': '8',
        'type': 'follow',
        'userName': 'open_source',
        'userAvatar': 'O',
        'bio': 'Flutter Package Maintainer',
        'time': now.subtract(const Duration(days: 7)),
        'isUnread': false,
        'isFollowing': false,
      },
    ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: _markAllAsRead,
                child: Chip(
                  label: Text('$_unreadCount new'),
                  backgroundColor: Colors.blue,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No notifications yet',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'When you get notifications, they\'ll appear here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length + 1, // +1 for header
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader();
        }
        
        final notification = _notifications[index - 1];
        return _buildNotificationItem(notification, index - 1);
      },
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$_unreadCount unread • ${_notifications.length} total',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                if (_unreadCount > 0)
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: const Text('Mark all as read'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Notification message
                  _buildNotificationMessage(notification),
                  
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  _buildActionButtons(notification, index),
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
              onPressed: () => _toggleReadStatus(index),
              tooltip: notification['isUnread'] ? 'Mark as read' : 'Mark as unread',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationMessage(Map<String, dynamic> notification) {
    switch (notification['type']) {
      case 'like':
        return Text(
          'liked your post: "${notification['postPreview']}"',
        );
        
      case 'comment':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'commented on your post: "${notification['postPreview']}"',
            ),
            const SizedBox(height: 4),
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        );
        
      case 'mention':
        return Text(
          'mentioned you in a post: "${notification['postPreview']}"',
        );
        
      case 'share':
        return Text(
          'shared your post: "${notification['postPreview']}"',
        );
        
      default:
        return const Text('sent you a notification');
    }
  }

  Widget _buildActionButtons(Map<String, dynamic> notification, int index) {
    final actions = <Widget>[];
    
    // Follow back button for follow notifications
    if (notification['type'] == 'follow' && !notification['isFollowing']) {
      actions.add(
        ElevatedButton(
          onPressed: () => _followBack(index),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Follow Back'),
        ),
      );
    }
    
    // View post button for post-related notifications
    if (['like', 'comment', 'mention', 'share'].contains(notification['type'])) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 8));
      }
      actions.add(
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Viewing ${notification['userName']}\'s post'),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('View Post'),
        ),
      );
    }
    
    // Like/Comment buttons for comment notifications
    if (notification['type'] == 'comment') {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 8));
      }
      actions.add(
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Liked the comment')),
            );
          },
          icon: const Icon(Icons.favorite_border, size: 16),
          label: const Text('Like'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions,
    );
  }
}