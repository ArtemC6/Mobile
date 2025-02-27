import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:voccent/audio/audio_metadata.dart';

class AudioBlob {
  Future<void> init() async {
    final p = await FFmpegKitConfig.registerNewFFmpegPipe();

    await FFmpegKitConfig.closeFFmpegPipe(p!);

    _pcmPipe = p;
  }

  final Duration _delay = const Duration(milliseconds: 50);
  late final String _pcmPipe;
  bool exists() => File(_pcmPipe).existsSync();

  Future<void> clear() async {
    if (exists()) {
      await File(_pcmPipe).delete();
    }
  }

  Future<int> get length {
    if (exists()) {
      return File(_pcmPipe).length();
    }

    return Future.value(0);
  }

  Future<void> appendPcmBlob(Uint8List pcm) =>
      File(_pcmPipe).writeAsBytes(pcm, mode: FileMode.append, flush: true);

  Future<Uint8List> asPcmBlob() => File(_pcmPipe).readAsBytes();

  Future<void> rewriteWithOggBlob(
    Uint8List ogg, {
    AudioMetadata? metadata,
  }) async {
    final oggPipe = await FFmpegKitConfig.registerNewFFmpegPipe();
    await FFmpegKitConfig.closeFFmpegPipe(oggPipe!);

    final volume = ((metadata?.volume ?? 100) / 100).toStringAsFixed(1);

    final completer = Completer<void>();

    await Future.wait([
      File(oggPipe).writeAsBytes(
        ogg,
        mode: FileMode.writeOnly,
        flush: true,
      ),
      Future<void>.delayed(_delay).then(
        (_) => FFmpegKit.executeAsync(
          '-loglevel error -f ogg -i $oggPipe '
          '-c:a pcm_s16le -y -f s16le -ar 48000 -ac 1 '
          '-filter:a "volume=$volume" $_pcmPipe',
          (session) async {
            final returnCode = await session.getReturnCode();

            await File(oggPipe).delete();

            if (ReturnCode.isSuccess(returnCode)) {
              completer.complete();
            } else {
              completer.completeError(
                Exception('9a0e257c: cannot convert ogg->pcm.'),
              );
            }
          },
        ),
      ),
    ]);

    await completer.future;
  }

  Future<Uint8List> asOggBlob() async {
    final oggPipe = await FFmpegKitConfig.registerNewFFmpegPipe();
    await FFmpegKitConfig.closeFFmpegPipe(oggPipe!);

    final task = Completer<Uint8List>();

    await FFmpegKit.executeAsync(
      '-loglevel error -y -f s16le -ar 48000 -ac 1 -i $_pcmPipe '
      '-c:a libopus -f ogg $oggPipe',
      (session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          final r = await File(oggPipe).readAsBytes();

          await File(oggPipe).delete();

          task.complete(r);
        } else {
          task.completeError(
            Exception('29444adc: cannot convert pcm->ogg.'),
          );
        }
      },
    );

    return task.future;
  }

  Future<Duration> duration() async =>
      Duration(milliseconds: ((await length) / 96).floor());

  Future<void> close() async {
    await FFmpegKitConfig.closeFFmpegPipe(_pcmPipe);
    await clear();
  }
}
