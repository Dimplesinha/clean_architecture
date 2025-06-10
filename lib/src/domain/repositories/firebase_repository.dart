import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workapp/firebase_options.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/notification/helper/local_notification_helper.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 07/11/23
/// @Message : [FirebaseRepository]
///
class FirebaseRepository {
  static final FirebaseRepository _singleton = FirebaseRepository._internal();

  FirebaseRepository._internal();

  static FirebaseRepository get instance => _singleton;

  Future<void> initAllServices() async {
    await setupFirebaseServices();
  }

  /// Initialize all Firebase Services
  Future<void> setupFirebaseServices() async {
    /// FirebaseApp
    var firebaseAppConfigured = await configureFirebaseApp();
    ConsoleLogger.instance.print(firebaseAppConfigured);

    /// Crashlytics
    var crashlyticsConfigure = await setupCrashlytics();
    ConsoleLogger.instance.print(crashlyticsConfigure);

    var token = await FirebaseMessaging.instance.getToken();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    /// For Notification in foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      NotificationHelper.showNotification();
    });

    /// For Notification in background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {});

    /// For Notification in terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {});

    getFcmTokenFirstTime();

    ConsoleLogger.instance.print(token.toString());
  }

  /// Firebase Crashlytics
  Future<String> setupCrashlytics() async {
    final firebaseCrashlyticsFuture = Completer<String>();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    firebaseCrashlyticsFuture.complete('Firebase Crashlytics Initialized!');
    return firebaseCrashlyticsFuture.future;
  }

  /// Firebase configure app as per the current platform
  Future<String> configureFirebaseApp() async {
    final firebaseConfigFuture = Completer<String>();
    String data = '';
    try {
      data = await rootBundle.loadString(AssetPath.firebaseConfigJson);
    } catch (ex) {
      firebaseConfigFuture.completeError(ex);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text('$ex')));
    }
    assert(data.isNotEmpty, 'Firebase config map must not be empty!');

    late FirebaseOptions firebaseOptions;
    try {
      var decodedJson = json.decode(data);
      var map = decodedJson as Map<String, dynamic>;

      assert(map.isNotEmpty, 'Decoded config json must not be empty');

      /// Asserts to make sure our map contains the necessary keys for the firebase setup
      var errorSuffixStr = AppConstants.keyRequiredFirebaseConfigStr;

      assert(map.containsKey(ModelKeys.androidApiKey), '${ModelKeys.androidApiKey} $errorSuffixStr');
      assert(map.containsKey(ModelKeys.iOSApiKey), '${ModelKeys.iOSApiKey} $errorSuffixStr');
      assert(map.containsKey(ModelKeys.androidAppId), '${ModelKeys.androidAppId} $errorSuffixStr');
      assert(map.containsKey(ModelKeys.iosAppId), '${ModelKeys.iosAppId} $errorSuffixStr');
      assert(map.containsKey(ModelKeys.messagingSenderId), '${ModelKeys.messagingSenderId} $errorSuffixStr');
      assert(map.containsKey(ModelKeys.projectId), '${ModelKeys.projectId} $errorSuffixStr');

      firebaseOptions = DefaultFirebaseOptions.buildPlatformConfig(map);
      await Firebase.initializeApp(options: firebaseOptions);
      if (!firebaseConfigFuture.isCompleted) {
        firebaseConfigFuture.complete('Firebase App Configured!');
      }
    } catch (ex) {
      if (!firebaseConfigFuture.isCompleted) {
        firebaseConfigFuture.completeError(ex);
      }
      rethrow; // log the error details into console
    }
    return firebaseConfigFuture.future;
  }

  // Fetch FCM token first time from firebase
  Future<String> getFcmTokenFirstTime() async {
    String? token = await PreferenceHelper.instance.getPreference(key: PreferenceHelper.fcmToken);
    if (token!.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      token = await FirebaseMessaging.instance.getToken();
      await PreferenceHelper.instance.setPreference(key: PreferenceHelper.fcmToken, value: token ?? '');
    }
    return token ?? '';
  }

  // Fetch FCM token while login and sign up
  Future<String> getFcmToken() async {
    String? token = await PreferenceHelper.instance.getPreference(key: PreferenceHelper.fcmToken);
    return token ?? '';
  }
}
