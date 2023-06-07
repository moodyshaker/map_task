import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../appStorage/shared_preference.dart';

class FirebaseNotifications {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static String? fcm;

  static Future<String?> getFCM() async {
    fcm = await _firebaseMessaging.getToken();
    await Preferences.instance.setFcmToken(fcm);
    log(fcm!);
    return fcm;
  }
}
