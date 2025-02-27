import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:voccent/crashlytics_bloc_observer.dart';
import 'package:voccent/firebase_options.dart';
import 'package:voccent/root/root_widget.dart' as root_widget;

Future<void> main({String host = 'app.voccent.com'}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  if (!kIsWeb) {
    Bloc.observer = CrashlyticsBlocObserver();

    final data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());

    await Intercom.instance.initialize(
      'edpyhr5x',
      iosApiKey: 'ios_sdk-38dc77f4ce5d22bd714727122220a637497c7c1a',
      androidApiKey: 'android_sdk-29a3c70e12583d316f25d01828b176e030c67214',
    );

    if (kDebugMode) {
      await Upgrader.clearSavedSettings();
    }
  }

  runApp(
    root_widget.RootWidget(
      host,
      await SharedPreferences.getInstance(),
    ),
  );
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  try {
    log('Received notification: $data');

    // Notification title
    final notificationTitle = data['Title'] as String? ?? 'Voccent';

    // Attempt to extract the "Message" property from the payload:
    // {"Message":"Hello World!"}
    final notificationText = data['Message'] as String? ?? '';

    // `S.current...` doesn't work when the app is in background (Android)
    // if ((data['Type'] as String?) == 'new_chat_message') {
    //   notificationText = S.current.notificationNewChatMessage;
    // }

    // Android: Displays a system notification
    // iOS: Displays an alert dialog
    Pushy.notify(notificationTitle, notificationText, data);

    // Clear iOS app badge number
    Pushy.clearBadge();
  } catch (e) {
    // ignore
  }
}
