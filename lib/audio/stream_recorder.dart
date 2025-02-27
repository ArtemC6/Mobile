// ignore_for_file: avoid_redundant_argument_values
import 'dart:async';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart' show Level;
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/audio/audio_blob.dart';

const int bytesPerMs = 96;

class StreamRecorder {
  RecorderState get recorderStatus => _recorder.recorderState;
  Stream<Uint8List> get oggStream => _dataStreamController.stream;

  final _dataStreamController = StreamController<Uint8List>.broadcast();
  final _recorder = FlutterSoundRecorder(logLevel: Level.error);
  final _lock = Lock();

  final List<AudioBlob> _audioBlobs = <AudioBlob>[];
  late final int _intervalMs;
  late final int _rateMs;

  Future<void> init({int intervalMs = 5000, int rateMs = 5000}) async {
    _intervalMs = intervalMs;
    _rateMs = rateMs;

    _audioBlobs.addAll(
      List<AudioBlob>.generate(
        intervalMs ~/ rateMs + 1,
        (index) => AudioBlob(),
      ),
    );

    await Future.wait(_audioBlobs.map((e) => e.init()));

    await startRecorder();
  }

  late final _recordingDataController = StreamController<Food>()
    ..stream.listen((buffer) {
      if (buffer is FoodData) {
        _lock.synchronized<void>(() => _appendBuffer(buffer.data!));
      }
    });

  Future<void> _appendBuffer(Uint8List buffer) async {
    await _audioBlobs.first.appendPcmBlob(buffer);

    for (var i = 1; i < _audioBlobs.length; i++) {
      if (await _audioBlobs[i - 1].length - await _audioBlobs[i].length >
          bytesPerMs * _rateMs) {
        await _audioBlobs[i].appendPcmBlob(buffer);
      }
    }

    while (await _audioBlobs.first.length > bytesPerMs * _intervalMs) {
      final Uint8List ogg;
      try {
        ogg = await _audioBlobs.first.asOggBlob();
      } on MissingPluginException {
        await stopRecorder();
        rethrow;
      }

      if (!_dataStreamController.isClosed) {
        _dataStreamController.sink.add(ogg);
        log('Recorded ${ogg.lengthInBytes}B ogg blob', name: 'StreamRecorder');
      }

      await _audioBlobs.first.clear();

      _audioBlobs
        ..add(_audioBlobs.first)
        ..removeAt(0);
    }
  }

  Future<void> _toRecorderMode() async {
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  /// - Switches to recording mode
  /// - Starts recorder
  Future<void> startRecorder() async {
    await _toRecorderMode();

    await Future.wait(_audioBlobs.map((e) => e.clear()));

    await _recorder.startRecorder(
      toStream: _recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 48000,
    );
  }

  Future<void> stopRecorder() => _recorder.stopRecorder();

  Future<void> close() => Future.wait(<Future<void>>[
        _recordingDataController.close(),
        _dataStreamController.close(),
        ..._audioBlobs.map((e) => e.close()),
        _recorder.closeRecorder(),
      ]);
}
