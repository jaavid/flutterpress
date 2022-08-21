import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/models/notification_model.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:kermaneno/utils/notification_dialog.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final String subscriptionTopic = 'all';

  Future _handleIosNotificationPermissaion() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future initFirebasePushNotification(context) async {
    if (Platform.isIOS) {
      _handleIosNotificationPermissaion();
    }
    String? _token = await _fcm.getToken();
    print('User FCM Token : $_token');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    debugPrint('inittal message : $initialMessage');
    if (initialMessage != null) {
      await saveNotificationData(initialMessage)
          .then((value) => _navigateToDetailsScreen(context, initialMessage));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('onMessage: ${message.notification!.body}');
      await saveNotificationData(message)
          .then((value) => _handleOpenNotificationDialog(context, message));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await saveNotificationData(message)
          .then((value) => _navigateToDetailsScreen(context, message));
    });
  }

  Future _handleOpenNotificationDialog(context, RemoteMessage message) async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    NotificationModel notificationModel = NotificationModel(
        timestamp: _timestamp,
        date: message.sentTime,
        title: message.notification!.title,
        body: message.notification!.body,
        postID: message.data['post_id'] == null
            ? null
            : int.parse(message.data['post_id']),
        thumbnailUrl: message.data['image']);
    openNotificationDialog(context, notificationModel);
  }

  Future _navigateToDetailsScreen(context, RemoteMessage message) async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    NotificationModel notificationModel = NotificationModel(
        timestamp: _timestamp,
        date: message.sentTime,
        title: message.notification!.title,
        body: message.notification!.body,
        postID: message.data['post_id'] == null
            ? null
            : int.parse(message.data['post_id']),
        thumbnailUrl: message.data['image']);
    navigateToNotificationDetailsScreen(context, notificationModel);
  }

  Future saveNotificationData(RemoteMessage message) async {
    final list = Hive.box(Constants.notificationTag);
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    Map<String, dynamic> _notificationData = {
      'timestamp': _timestamp,
      'date': message.sentTime,
      'title': message.notification!.title,
      'body': message.notification!.body,
      'post_id': message.data['post_id'],
      'image': message.data['image']
    };

    await list.put(_timestamp, _notificationData);
  }

  Future deleteNotificationData(key) async {
    final bookmarkedList = Hive.box(Constants.notificationTag);
    await bookmarkedList.delete(key);
  }

  Future deleteAllNotificationData() async {
    final bookmarkedList = Hive.box(Constants.notificationTag);
    await bookmarkedList.clear();
  }

  Future<bool> handleFcmSubscribtion() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _subscription = sp.getBool('subscribed') ?? true;
    if (_subscription == true) {
      _fcm.subscribeToTopic(subscriptionTopic);
      debugPrint('subscribed');
    } else {
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      debugPrint('unsubscribed');
    }

    return _subscription;
  }
}
