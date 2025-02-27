import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/auth/cubit/user_status.dart';
import 'package:voccent/home/cubit/models/dice/dice.dart';
import 'package:voccent/main.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/route/app_pages.dart';

class PushyWidget extends StatefulWidget {
  const PushyWidget({required Widget child, super.key}) : _child = child;

  final Widget _child;

  @override
  State<PushyWidget> createState() => _PushyWidgetState();
}

class _PushyWidgetState extends State<PushyWidget> {
  @override
  void initState() {
    super.initState();

    if (context.read<AuthCubit>().state.userStatus ==
        UserStatus.authenticated) {
      _registerPushyDevice(context.read<UserScopeClient>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.userStatus != UserStatus.authenticated &&
          current.userStatus == UserStatus.authenticated,
      listener: (context, state) =>
          _registerPushyDevice(context.read<UserScopeClient>()),
      child: widget._child,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method
  Future<void> _registerPushyDevice(UserScopeClient http) async {
    if (kIsWeb) {
      return;
    }

    log('Registering device...', name: 'Pushy');
    // Start the Pushy service
    Pushy.listen();

    Pushy.toggleMethodSwizzling(false);

    // Enable FCM Fallback Delivery
    Pushy.toggleFCM(true);

    // Set custom notification icon (Android)
    Pushy.setNotificationIcon('ic_launcher');

    // Register the device for push notifications
    try {
      final deviceToken = await Pushy.register();

      // Print token to console/logcat
      log('Device token: $deviceToken', name: 'Pushy');

      // Send the token to your backend server
      await http.post(
        Uri.parse('/api/v1/pushy/register'),
        body: '{"DeviceToken":"$deviceToken"}',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      // Enable in-app notification banners (iOS 10+)
      if (Platform.isIOS) {
        Pushy.toggleInAppBanner(false);
      } else if (Platform.isAndroid) {
        Pushy.toggleInAppBanner(true);
      }

      // Listen for push notifications received
      Pushy.setNotificationListener(backgroundNotificationListener);

      _setNotificationClickListener();
    } on PlatformException {
      log(
        'The app push notifications are not permitted by the user',
        name: 'Pushy',
      );
    }
  }

  void _setNotificationClickListener() {
    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      FirebaseCrashlytics.instance
          .log('98bc0490: Clicked notification: `$data`');

      FirebaseAnalytics.instance.logEvent(
        name: 'notification_clicked',
        parameters: {
          'event_category': 'Notifications',
          'event_label': data['Type'] as String?,
        },
      );

      if (data['Link'] != null) {
        context.read<AppPages>().router.go(data['Link'] as String);
      } else if (data['Data'] as String != '') {
        final chatDataJson = data['Data'] as String;
        final chatData = jsonDecode(chatDataJson) as Map<String, dynamic>;
        final chatMessageData =
            chatData['ChatMessage'] as Map<String, dynamic>?;
        if (chatMessageData?['ObjectType'] == 'classroom') {
          final objectId = chatMessageData?['ObjectID'] as String?;
          final objectName = chatMessageData?['ObjectName'] as String?;
          final cache = context.read<ServerAddress>().cacheImgHash();
          context.read<AppPages>().router.go(
                '/activity_chat',
                extra: ActivityChatData(
                  operationId: 'classroom_$objectId',
                  title: objectName ?? '',
                  imagePath:
                      '/api/v1/asset/object/classroom_picture/$objectId?time=$cache',
                  bannerPath:
                      '/api/v1/asset/object/classroom_banner/$objectId?time=$cache',
                ),
              );
        } else {
          context.read<AppPages>().router.go('/');
        }
      } else {
        Dice.fetchDice(context.read<UserScopeClient>()).then((dice) {
          context.read<AppPages>().router.push(
                '/${dice.$2}/${dice.$1}',
              );
        });
      }

      // Clear iOS app badge number
      Pushy.clearBadge();
    });
  }
}
