// ignore_for_file: avoid_redundant_argument_values
import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:logger/logger.dart' show Level;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soundpool/soundpool.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/audio/audio_blob.dart';
import 'package:voccent/audio/audio_metadata.dart';

class AudioIo {
  late Soundpool _pool;
  late int _startSound;
  late int _stopSound;

  final _refPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final _backgroundPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final _background2Player = FlutterSoundPlayer(logLevel: Level.error);
  final _testPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final _highlightPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final _recorder = FlutterSoundRecorder(logLevel: Level.error);

  late final AudioBlob _refWave;
  late final AudioBlob _testWave;
  late final File _testWaveFile;
  late final AudioBlob _highlightWave;
  late final AudioBlob _backgroundWave;
  late final AudioBlob _background2Wave;

  PlayerState get refPlayerStatus => _refPlayer.playerState;

  PlayerState get testPlayerStatus => _testPlayer.playerState;

  PlayerState get highlightPlayerStatus => _highlightPlayer.playerState;

  PlayerState get background2PlayerStatus => _background2Player.playerState;

  RecorderState get recorderStatus => _recorder.recorderState;
  bool isInited = false;
  bool _isFadeInProgress = false;
  final Lock _lock = Lock();

  static const _smoothAudio = 30;
  static const _audioQuantity = 0.01;

  Future<void> init() async {
    if (kIsWeb || isInited) {
      return;
    }

    _refWave = AudioBlob();
    _backgroundWave = AudioBlob();
    _background2Wave = AudioBlob();
    _testWave = AudioBlob();
    final tempDir = await getTemporaryDirectory();
    final testWavePath = '${tempDir.path}/testWaveAudio.pcm';
    _testWaveFile = File(testWavePath);
    _highlightWave = AudioBlob();

    await Future.wait([
      _refWave.init(),
      _backgroundWave.init(),
      _background2Wave.init(),
      _testWave.init(),
      _highlightWave.init(),
    ]);

    await _initBeepBoopSounds();
    isInited = true;
  }

  Future<bool> testTooShort() async {
    final duration = await refDuration() * 0.6;
    final durationCurrent = await testDuration();

    if (duration > durationCurrent) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _toPlayerMode() async {
    await _recorder.closeRecorder();

    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );

    await _refPlayer.openPlayer();
    await _backgroundPlayer.openPlayer();
    await _background2Player.openPlayer();

    if (_background2Player.isPaused) await _background2Player.resumePlayer();
    await _testPlayer.openPlayer();
    await _highlightPlayer.openPlayer();
  }

  Future<void> unmutePlayers() async {
    if (!isInited) {
      return;
    }

    if (_refPlayer.isOpen()) {
      await _refPlayer.setVolume(1);
    }

    if (_testPlayer.isOpen()) {
      await _testPlayer.setVolume(1);
    }

    if (_backgroundPlayer.isOpen()) {
      await _backgroundPlayer.setVolume(1);
    }

    if (!_back2Muted && _background2Player.isOpen()) {
      await _background2Player.setVolume(1);
    }

    if (_highlightPlayer.isOpen()) {
      await _highlightPlayer.setVolume(1);
    }
  }

  Future<void> mutePlayers() async {
    if (!isInited) {
      return;
    }

    if (_refPlayer.isOpen()) {
      await _refPlayer.setVolume(0);
    }

    if (_testPlayer.isOpen()) {
      await _testPlayer.setVolume(0);
    }

    if (_backgroundPlayer.isOpen()) {
      await _backgroundPlayer.setVolume(0);
    }

    if (_background2Player.isOpen()) {
      await _background2Player.setVolume(0);
    }

    if (_highlightPlayer.isOpen()) {
      await _highlightPlayer.setVolume(0);
    }
  }

  bool _back2Muted = false;
  Future<void> muteUnmuteBackground2() async {
    if (!isInited || !_background2Player.isOpen()) {
      return;
    }

    if (_back2Muted) {
      await _background2Player.setVolume(1);
    } else {
      await _background2Player.setVolume(0);
    }

    _back2Muted = !_back2Muted;
  }

  Future<void> _toRecorderMode() async {
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _refPlayer.closePlayer();
    await _backgroundPlayer.closePlayer();
    await _testPlayer.closePlayer();
    await _highlightPlayer.closePlayer();
    await _recorder.openRecorder();
    if (_background2Player.isPlaying) await _background2Player.pausePlayer();

    final session = await AudioSession.instance;
    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        // avAudioSessionMode: AVAudioSessionMode.spokenAudio,
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

  Future<void> _initBeepBoopSounds() async {
    _pool = Soundpool.fromOptions();
    _startSound =
        await rootBundle.load('assets/audio/start-1.mp3').then(_pool.load);
    _stopSound =
        await rootBundle.load('assets/audio/stop-1.mp3').then(_pool.load);

    await _pool.setVolume(soundId: _startSound, volume: 0.8);
    await _pool.setVolume(soundId: _stopSound, volume: 0.8);
  }

  Future<void> rewriteRefWithOggBlob(
    Uint8List blob, {
    AudioMetadata? metadata,
  }) async {
    await _lock.synchronized(() async {
      assert(_refPlayer.playerState == PlayerState.isStopped, 'Not ready');
      return _refWave.rewriteWithOggBlob(blob, metadata: metadata);
    });
  }

  Future<void> rewriteBackgroundWithOggBlob(
    Uint8List blob, {
    AudioMetadata? metadata,
  }) async {
    await _lock.synchronized(() async {
      assert(
        _backgroundPlayer.playerState == PlayerState.isStopped,
        'Not ready',
      );
      return _backgroundWave.rewriteWithOggBlob(blob, metadata: metadata);
    });
  }

  Future<void> rewriteBackground2WithOggBlob(
    Uint8List blob, {
    AudioMetadata? metadata,
  }) async {
    await _lock.synchronized(() async {
      assert(
        _background2Player.playerState == PlayerState.isStopped,
        'Not ready',
      );
      return _background2Wave.rewriteWithOggBlob(blob, metadata: metadata);
    });
  }

  Future<void> rewriteTestWithOggBlob(
    Uint8List blob, {
    AudioMetadata? metadata,
  }) async {
    await _lock.synchronized(() async {
      assert(_testPlayer.playerState == PlayerState.isStopped, 'Not ready');
      return _testWave.rewriteWithOggBlob(blob, metadata: metadata);
    });
  }

  Future<void> rewriteHighlightWithOggBlob(
    Uint8List blob, {
    AudioMetadata? metadata,
  }) async {
    await _lock.synchronized(() async {
      assert(
        _highlightPlayer.playerState == PlayerState.isStopped,
        'Not ready',
      );
      return _highlightWave.rewriteWithOggBlob(blob, metadata: metadata);
    });
  }

  Future<Uint8List> testOggBlob() {
    return _testWave.asOggBlob();
  }

  Future<Uint8List> highlightOggBlob() {
    return _highlightWave.asOggBlob();
  }

  Future<void> startRefPlayer({TWhenFinished? whenFinished}) async {
    await _lock.synchronized(() async {
      await _toPlayerMode();
      await _refPlayer.startPlayer(
        fromDataBuffer: await _refWave.asPcmBlob(),
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 48000,
        whenFinished: () {
          whenFinished?.call();

          Future.delayed(
            const Duration(milliseconds: 500),
            _backgroundPlayer.stopPlayer,
          );
        },
      );

      if (_backgroundWave.exists()) {
        await _backgroundPlayer.startPlayer(
          fromDataBuffer: await _backgroundWave.asPcmBlob(),
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: 48000,
        );

        unawaited(_fadeBackgroundPlayer());
      }
    });
  }

  Future<void> _fadeBackgroundPlayer() async {
    _isFadeInProgress = true;
    for (var i = _audioQuantity; i <= 1.0; i += _audioQuantity) {
      if (!_isFadeInProgress) break;
      await Future.delayed(
        const Duration(milliseconds: _smoothAudio),
        () async {
          if (_backgroundPlayer.isPlaying) {
            await _backgroundPlayer.setVolume(i);
          }
        },
      );
    }
  }

  Future<void> _attenuationBackgroundPlayer() async {
    _isFadeInProgress = false;
    for (var i = 1.0; i >= _audioQuantity; i -= _audioQuantity) {
      if (_isFadeInProgress) break;
      await Future.delayed(
        const Duration(milliseconds: _smoothAudio),
        () async {
          if (_backgroundPlayer.isPlaying) {
            await _backgroundPlayer.setVolume(i);
          }
        },
      );
    }
  }

  Future<void> startTestPlayer({TWhenFinished? whenFinished}) async {
    await _lock.synchronized(() async {
      await _toPlayerMode();
      await _testPlayer.startPlayer(
        fromDataBuffer: await _testWave.asPcmBlob(),
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 48000,
        whenFinished: whenFinished,
      );
    });
  }

  Future<void> startHighlightPlayer({
    TWhenFinished? whenFinished,
  }) async {
    await _lock.synchronized(() async {
      await _toPlayerMode();
      await _highlightPlayer.startPlayer(
        fromDataBuffer: await _highlightWave.asPcmBlob(),
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 48000,
        whenFinished: whenFinished,
      );
    });
  }

  Future<void> startBackground2Player() async {
    await _lock.synchronized(() async {
      if (!_background2Wave.exists()) return;
      await _toPlayerMode();
      await _background2Player.startPlayer(
        fromDataBuffer: await _background2Wave.asPcmBlob(),
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 48000,
        whenFinished: startBackground2Player,
      );

      if (_back2Muted) await _background2Player.setVolume(0);
    });
  }

  Future<void> stopBackground2Player() async {
    await _lock.synchronized(() async {
      await _background2Player.stopPlayer();
    });
  }

  Future<void> clearBackground2Player() async {
    await _lock.synchronized(() async {
      await _background2Wave.clear();
    });
  }

  Future<void> stopRefPlayer() async {
    await _lock.synchronized(() async {
      if (_backgroundPlayer.isPlaying) {
        unawaited(
          _attenuationBackgroundPlayer(),
        );
      }

      await _refPlayer.stopPlayer();
      await _backgroundPlayer.stopPlayer();
    });
  }

  Future<void> stopTestPlayer() async {
    await _lock.synchronized(() async {
      return _testPlayer.stopPlayer();
    });
  }

  Future<void> stopHighlightPlayer() async {
    await _lock.synchronized(() async {
      return _highlightPlayer.stopPlayer();
    });
  }

  /// - Plays beep sound
  /// - Waits when the beep sound is finished
  /// - Switches to recording mode
  /// - Starts recorder
  Future<void> startRecorder() async {
    await _lock.synchronized(() async {
      await _pool.setVolume(soundId: _startSound, volume: 0.8);
      await _pool.setVolume(soundId: _stopSound, volume: 0.8);

      final startSoundFuture = _pool.play(_startSound);

      final delay = Future<void>.delayed(const Duration(milliseconds: 470));

      if (_testWaveFile.existsSync()) {
        await _testWaveFile.delete();
      }
      await _testWaveFile.create();
      await startSoundFuture;
      await delay;

      await _toRecorderMode();

      await _testWave.clear();
      await _highlightWave.clear();

      await _recorder.startRecorder(
        codec: Codec.pcm16,
        toFile: _testWaveFile.path,
        numChannels: 1,
        sampleRate: 48000,
        bitRate: 48000,
        audioSource: AudioSource.voice_recognition,
      );
    });
  }

  Future<void> stopRecorder() async {
    await _lock.synchronized(() async {
      await _recorder.stopRecorder();

      final wavePcmData = await _testWaveFile.readAsBytes();
      await _testWave.appendPcmBlob(wavePcmData);

      await _toPlayerMode();
      await _pool.play(_stopSound);
    });
  }

  Future<Duration> refDuration() {
    return _refWave.duration();
  }

  Future<Duration> testDuration() {
    return _testWave.duration();
  }

  Future<Duration> highlightDuration() {
    return _highlightWave.duration();
  }

  Future<void> seekToTestPlayer(Duration duration) {
    return _testPlayer.seekToPlayer(duration);
  }

  Future<void> seekToRefPlayer(Duration duration) {
    return _refPlayer.seekToPlayer(duration);
  }

  Future<void> seekToHighlightPlayer(Duration duration) {
    return _highlightPlayer.seekToPlayer(duration);
  }

  Future<void> close() async {
    await _lock.synchronized(() async {
      final tasks = <Future<dynamic>>[];

      if (isInited) {
        tasks
          ..add(_pool.release())
          ..add(_refWave.close())
          ..add(_testWave.close())
          ..add(_highlightWave.close())
          ..add(_backgroundWave.close())
          ..add(_background2Wave.close())
          ..add(_refPlayer.closePlayer())
          ..add(_backgroundPlayer.closePlayer())
          ..add(_background2Player.closePlayer())
          ..add(_testPlayer.closePlayer())
          ..add(_highlightPlayer.closePlayer())
          ..add(_recorder.closeRecorder());
      }

      await Future.wait(tasks);
    });
  }

  Future<void> stopAll() async {
    await _lock.synchronized(() async {
      await Future.wait([
        _refPlayer.stopPlayer(),
        _backgroundPlayer.stopPlayer(),
        // _background2Player.stopPlayer(),
        _testPlayer.stopPlayer(),
        _highlightPlayer.stopPlayer(),
        _recorder.stopRecorder(),
      ]);
    });
  }

  Future<void> clearAll() async {
    await _lock.synchronized(() async {
      await Future.wait([
        _refWave.clear(),
        _backgroundWave.clear(),
        // _background2Wave.clear(),
        _testWave.clear(),
        _highlightWave.clear(),
      ]);
    });
  }
}
