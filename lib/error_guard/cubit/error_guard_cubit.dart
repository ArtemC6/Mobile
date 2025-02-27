import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

part 'error_guard_state.dart';

class ErrorGuardCubit extends Cubit<ErrorGuardState> {
  ErrorGuardCubit() : super(ErrorGuardState(Object(), DateTime(0))) {
    EquatableConfig.stringify = true;
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
      FirebaseCrashlytics.instance.setCustomKey('debugMode', kDebugMode);
    }

    FlutterError.onError = (details) {
      if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed ||
          details.exception.runtimeType == NetworkImageLoadException ||
          details.exception.runtimeType == SocketException ||
          details.exception.runtimeType == HttpException ||
          details.exception.runtimeType == WebSocketException) {
        return;
      }

      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }

      if (!isClosed) {
        emit(ErrorGuardState(details.exception, DateTime.now()));
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed ||
          error is SocketException ||
          error is WebSocketException) {
        return true;
      }

      if (!kIsWeb && error is! ShakeException) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }

      if (!isClosed) {
        emit(ErrorGuardState(error, DateTime.now()));
      }

      return true;
    };

    FFmpegKitConfig.enableLogCallback(
      (l) {
        log(l.getMessage(), name: 'FFmpeg');
        FirebaseCrashlytics.instance.log(l.getMessage());
      },
    );

    ShakeDetector.autoStart(onPhoneShake: () => throw ShakeException());
  }

  void enableUi() {
    emit(ErrorGuardState(state.error, state.occuredAt));
  }

  void disableUi() {
    emit(ErrorGuardState(state.error, state.occuredAt, enabled: false));
  }
}

class ShakeException implements Exception {
  @override
  String toString() => '619567f5: Phone shake detected';
}
