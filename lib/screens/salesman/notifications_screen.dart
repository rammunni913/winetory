import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAllNotificationsAsRead();
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notificationProvider.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationProvider.notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification['isRead']
                        ? Colors.grey
                        : AppTheme.primaryColor,
                    child: Icon(
                      _getNotificationIcon(notification['type']),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    notification['title'],
                    style: TextStyle(
                      fontWeight: notification['isRead']
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['body']),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(notification['timestamp'].toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: notification['isRead']
                      ? null
                      : const Icon(
                          Icons.circle,
                          color: AppTheme.primaryColor,
                          size: 12,
                        ),
                  onTap: () {
                    if (!notification['isRead']) {
                      notificationProvider.markNotificationAsRead(notification['id']);
                    }
                    _showNotificationDetails(notification);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case AppConstants.notificationAssignment:
        return Icons.assignment;
      case AppConstants.notificationReminder:
        return Icons.alarm;
      case AppConstants.notificationAlert:
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _showNotificationDetails(dynamic notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['body']),
            const SizedBox(height: 16),
            Text(
              'Received: ${_formatDate(notification['timestamp'].toDate())}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
