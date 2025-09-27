import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/assignment_model.dart';
import '../utils/constants.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> initializeNotifications() async {
    try {
      // Request permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        String? token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');

        // Listen to foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _handleNotification(message);
        });

        // Listen to background messages
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleNotification(message);
        });
      }
    } catch (e) {
      setError('Failed to initialize notifications: ${e.toString()}');
    }
  }

  void _handleNotification(RemoteMessage message) {
    Map<String, dynamic> notification = {
      'id': message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': message.notification?.title ?? 'Wine TorY',
      'body': message.notification?.body ?? '',
      'data': message.data,
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    _notifications.insert(0, notification);
    notifyListeners();
  }

  Future<void> sendAssignmentNotification(AssignmentModel assignment) async {
    try {
      setLoading(true);
      setError(null);

      // Create notification document
      Map<String, dynamic> notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'Duty Assignment',
        'body': 'Today assigned: ${assignment.salesmanName} for ${assignment.shopName}, Mobile: ${assignment.shopContact}',
        'type': 'assignment',
        'salesmanId': assignment.salesmanId,
        'shopId': assignment.shopId,
        'assignmentId': assignment.id,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      await FirebaseFirestore.instance
          .collection(AppConstants.notificationsCollection)
          .add(notificationData);

      // Send FCM notification
      await _sendFCMNotification(
        assignment.salesmanId,
        'Duty Assignment',
        'Today assigned: ${assignment.salesmanName} for ${assignment.shopName}, Mobile: ${assignment.shopContact}',
        notificationData,
      );

      setLoading(false);
    } catch (e) {
      setError('Failed to send notification: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<void> sendGeneralNotification(String title, String body, {List<String>? targetUsers, List<String>? targetShops}) async {
    try {
      setLoading(true);
      setError(null);

      Map<String, dynamic> notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'body': body,
        'type': 'general',
        'targetUsers': targetUsers,
        'targetShops': targetShops,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      await FirebaseFirestore.instance
          .collection(AppConstants.notificationsCollection)
          .add(notificationData);

      // Send to specific users if provided
      if (targetUsers != null && targetUsers.isNotEmpty) {
        for (String userId in targetUsers) {
          await _sendFCMNotification(userId, title, body, notificationData);
        }
      }

      // Send to all users if no specific targets
      if (targetUsers == null || targetUsers.isEmpty) {
        await _sendFCMToAllUsers(title, body, notificationData);
      }

      setLoading(false);
    } catch (e) {
      setError('Failed to send notification: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<void> _sendFCMNotification(String userId, String title, String body, Map<String, dynamic> data) async {
    try {
      // Get user's FCM token from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? fcmToken = userData['fcmToken'];

        if (fcmToken != null) {
          // In a real implementation, you would send the FCM message from your backend
          // For now, we'll just store the notification in Firestore
          print('Would send FCM to token: $fcmToken');
        }
      }
    } catch (e) {
      print('Failed to send FCM notification: ${e.toString()}');
    }
  }

  Future<void> _sendFCMToAllUsers(String title, String body, Map<String, dynamic> data) async {
    try {
      // Get all users with FCM tokens
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .where('fcmToken', isNull: false)
          .get();

      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? fcmToken = userData['fcmToken'];

        if (fcmToken != null) {
          // In a real implementation, you would send the FCM message from your backend
          print('Would send FCM to token: $fcmToken');
        }
      }
    } catch (e) {
      print('Failed to send FCM to all users: ${e.toString()}');
    }
  }

  Future<void> fetchNotifications({String? userId}) async {
    try {
      setLoading(true);
      setError(null);

      Query query = FirebaseFirestore.instance
          .collection(AppConstants.notificationsCollection)
          .orderBy('timestamp', descending: true);

      if (userId != null) {
        query = query.where('salesmanId', isEqualTo: userId);
      }

      QuerySnapshot querySnapshot = await query.get();

      _notifications = querySnapshot.docs
          .map((doc) => {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch notifications: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});

      int index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
        notifyListeners();
      }
    } catch (e) {
      setError('Failed to mark notification as read: ${e.toString()}');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      for (Map<String, dynamic> notification in _notifications) {
        if (!notification['isRead']) {
          await markNotificationAsRead(notification['id']);
        }
      }
    } catch (e) {
      setError('Failed to mark all notifications as read: ${e.toString()}');
    }
  }

  int getUnreadCount() {
    return _notifications.where((n) => !n['isRead']).length;
  }

  Future<void> saveFCMToken(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({'fcmToken': token});
      }
    } catch (e) {
      setError('Failed to save FCM token: ${e.toString()}');
    }
  }
}
