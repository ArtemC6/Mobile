// ignore_for_file: non_constant_identifier_names, prefer_int_literals
class PID {
  /// A simple PID controller. No fuss.
  /// Directly ported from python: https://github.com/m-lundberg/simple-pid
  /// [Kp] is the value for the proportional gain.
  /// [Ki] is the value for the integral gain.
  /// [Kd] is the value for the derivative gain.
  /// [setPoint] is the initial setpoint that the PID will try to achieve.
  /// [sampleTime] is the time in seconds which
  /// the controller should wait before generating a new output value.
  /// The [PID] works best when it is constantly called (eg. during a loop),
  /// but with the
  /// [sampleTime] set so that the time difference between
  ///  each update is (close to) constant. If not set
  /// it will default to 0.01 seconds.
  /// [minOutput] is minimum output to use.
  /// [maxOutput] is the maximum output limit to use.
  /// If neither limit is set it defaults to a very large and very small number.
  /// These limits also avoid integral windup, since the integral term will
  /// never be allowed
  /// to grow outside of the limits.
  /// [autoMode] is whether the controller should be enabled (in auto mode) or
  /// not (in manual mode).
  /// [proportionalOnMeasurement] is whether the proportional term
  /// should be calculated on the input directly
  /// rather than on the error (which is the traditional way). Using
  /// proportional-on-measurement avoids overshoot for some types of systems.
  PID({
    this.Kp = 1.0,
    this.Ki = 0.0,
    this.Kd = 0.0,
    this.setPoint = 0.0,
    this.sampleTime = 0.01,
    this.minOutput = -double.maxFinite,
    this.maxOutput = double.maxFinite,
    this.proportionalOnMeasurement = false,
    bool autoMode = true,
  }) {
    _autoMode = autoMode;
    reset();
  }
  double Kp = 1.0;
  double Ki = 0.0;
  double Kd = 0.0;
  double setPoint = 0.0;
  double sampleTime = 0.01;
  double minOutput;
  double maxOutput;
  bool _autoMode = true;
  bool proportionalOnMeasurement = false;

  double proportional = 0;
  double integral = 0;
  double derivative = 0;

  late DateTime lastTime;
  late double lastOutput;
  double? lastInput;

  List<double> get tunings {
    return [Kp, Ki, Kd];
  }

  set tunings(List<double> t) {
    Kp = t[0];
    Ki = t[1];
    Kd = t[2];
  }

  List<double> get components {
    return [proportional, integral, derivative];
  }

  bool get autoMode {
    return _autoMode;
  }

  set autoMode(bool enabled) {
    if (enabled && !_autoMode) {
      reset();
    }

    _autoMode = enabled;
  }

  double call(double input, {Duration? dt}) {
    if (!autoMode) return lastOutput;

    final now = DateTime.now();
    dt ??= now.difference(lastTime);

    if (dt.inMicroseconds < 0) throw ArgumentError('dt must be positive');

    if (dt.inMicroseconds / 1000000 < sampleTime) {
      return lastOutput;
    }

    // compute error terms
    final error = setPoint - input;
    final dInput = input - (lastInput ?? 0);

    // compute the proportional term
    if (!proportionalOnMeasurement) {
      proportional = Kp * error;
    } else {
      proportional -= Kp * dInput;
    }

    // compute integral and derivative terms
    integral += Ki * error * dt.inMicroseconds / 1000000;
    integral = integral.clamp(minOutput, maxOutput);
    derivative = -Kd * dInput / dt.inMicroseconds / 1000000;

    // compute final output
    var output = proportional + integral + derivative;
    output = output.clamp(minOutput, maxOutput);

    lastOutput = output;
    lastInput = input;
    lastTime = now;

    return output;
  }

  void reset() {
    proportional = 0.0;
    integral = 0.0;
    derivative = 0.0;
    lastInput = null;
    lastOutput = (maxOutput + minOutput) / 2;
    lastTime = DateTime.now();
  }
}
