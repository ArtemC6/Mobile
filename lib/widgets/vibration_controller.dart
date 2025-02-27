import 'dart:async';

import 'package:vibration/vibration.dart';

class VibrationController {
  static Timer? _heartbeatTimer;

  /// Function for vibration on button press
  static void onPressedVibration() {
    Vibration.vibrate(
      intensities: [0, 64],
      pattern: [0, 50],
    );
  }

  static void startHeartbeatVibration() {
    Vibration.vibrate(
      pattern: [1000, 100, 100, 200, 100],
      intensities: [0, 64, 0, 32, 0],
    );
    _heartbeatTimer?.cancel();
    _heartbeatTimer =
        Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      Vibration.vibrate(
        pattern: [100, 100, 200, 100],
        intensities: [64, 0, 32, 0],
      );
    });
  }

  static void stopHeartbeatVibration() {
    _heartbeatTimer?.cancel();
    Vibration.cancel();
  }

  /// Function for vibration on error
  static void errorVibration() {
    Vibration.vibrate(
      duration: 0,
      intensities: [0, 128],
      pattern: [0, 500],
    );
  }
}
