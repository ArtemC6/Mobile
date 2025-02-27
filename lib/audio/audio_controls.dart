import 'dart:async';

import 'package:audio_service/audio_service.dart';

class AudioControls extends BaseAudioHandler with SeekHandler {
  final _playStreamController = StreamController<Object>.broadcast();
  final _pauseStreamController = StreamController<Object>.broadcast();
  final _stopStreamController = StreamController<Object>.broadcast();
  final _skipToPreviousStreamController = StreamController<Object>.broadcast();
  final _skipToNextStreamController = StreamController<Object>.broadcast();

  Stream<void> get playEventStream => _playStreamController.stream;
  Stream<void> get pauseEventStream => _pauseStreamController.stream;
  Stream<void> get stopEventStream => _stopStreamController.stream;
  Stream<void> get skipToPreviousEventStream =>
      _skipToPreviousStreamController.stream;
  Stream<void> get skipToNextEventStream => _skipToNextStreamController.stream;

  Future<void> init() {
    return AudioService.init(
      builder: () => this,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.voccent.voccent.channel',
        androidNotificationChannelName: 'Voccent Audio Service',
        androidNotificationOngoing: true,
      ),
    );
  }

  @override
  Future<void> play() {
    _playStreamController.add(Object());
    return super.play();
  }

  @override
  Future<void> pause() {
    _pauseStreamController.add(Object());
    return super.pause();
  }

  @override
  Future<void> stop() {
    _stopStreamController.add(Object());
    return super.stop();
  }

  @override
  Future<void> skipToPrevious() {
    _skipToPreviousStreamController.add(Object());
    return super.skipToPrevious();
  }

  @override
  Future<void> skipToNext() {
    _skipToNextStreamController.add(Object());
    return super.skipToNext();
  }
}
