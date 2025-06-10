// deeplink_helper.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/model_keys.dart';
import 'package:workapp/src/core/constants/route_constants.dart';
import 'package:workapp/src/core/routes/app_router.dart';

class DeepLinkHelper {
  static final DeepLinkHelper _instance = DeepLinkHelper._internal();
  factory DeepLinkHelper() => _instance;

  final GlobalKey<NavigatorState> navigatorKey;
  static const MethodChannel _channel = MethodChannel('app.channel.deeplink');
  bool _isInitialized = false;
  Function(String)? onLinkReceived;

  final String _baseHost = ApiConstant.baseUriDynamic;

  DeepLinkHelper._internal() : navigatorKey = GlobalKey<NavigatorState>() {
    if (Platform.isAndroid || Platform.isIOS) {
      _channel.setMethodCallHandler(_handleMethod);
    }
  }

  /// Initialize deep linking
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final initialLink = await _getInitialLink();
      if (initialLink != null) {
        await handleLink(initialLink);
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('DeepLink Initialization Error: $e');
    }
  }

  /// Get initial link when app starts
  Future<String?> _getInitialLink() async {
    try {
      return await _channel.invokeMethod('getInitialLink');
    } catch (e) {
      debugPrint('Error getting initial link: $e');
      return null;
    }
  }

  /// Handle method calls from native
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onDeepLink':
        final String link = call.arguments as String;
        await handleLink(link);
        return true;
      default:
        return null;
    }
  }

  /// Handle incoming deep links
  Future<void> handleLink(String link) async {
    try {
      final uri = Uri.parse(link);
      onLinkReceived?.call(link);

      if (_isAppDeepLink(uri)) {
        // Check if listingId exists in query parameters
        final listingId = uri.queryParameters['listingId'];
        if (listingId != null && listingId.isNotEmpty) {
          AppRouter.push(AppRoutes.itemDetailsViewRoute, args: {
            ModelKeys.itemId: listingId,
          });
        } else {
          AppRouter.push(AppRoutes.homeScreenRoute);
        }
      } else {
        await _launchInBrowser(link);
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
      AppRouter.push(AppRoutes.homeScreenRoute);
    }
  }

  /// Check if the link matches our base URL
  bool _isAppDeepLink(Uri uri) {
    return uri.host == _baseHost;
  }

  /// Launch URL in browser
  Future<void> _launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Could not launch $url');
      AppRouter.push(AppRoutes.homeScreenRoute);
    }
  }

  /// Cleanup resources
  void dispose() {
    _isInitialized = false;
  }
}