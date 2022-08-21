import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationBloc extends ChangeNotifier {

  bool _subscribed = true;
  bool? get subscribed => _subscribed;




  Future configureFcmSubscription(bool isSubscribed) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribed', isSubscribed);
    _subscribed = isSubscribed;
    NotificationService().handleFcmSubscribtion();
    notifyListeners();
  }

  Future checkSubscription() async {
    await NotificationService().handleFcmSubscribtion().then((bool subscription) {
      _subscribed = subscription;
      notifyListeners();

    });
  }

}
