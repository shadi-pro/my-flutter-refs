import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';

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
      return const Center(child: CircularProgressIndicator());
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    return NotificationItem(
      notification: notification,
      onToggleRead: () => _toggleReadStatus(index),
      onFollowBack:
          notification['type'] == 'follow' && !notification['isFollowing']
          ? () => _followBack(index)
          : null,
      onViewPost:
          ['like', 'comment', 'mention', 'share'].contains(notification['type'])
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Viewing ${notification['userName']}\'s post'),
                ),
              );
            }
          : null,
      onLikeComment: notification['type'] == 'comment'
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Liked the comment')),
              );
            }
          : null,
      showActions: true,
    );
  }
}
