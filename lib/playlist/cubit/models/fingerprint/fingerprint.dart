import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/fingerprint_data_joined_segments34530eeb.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';

part 'fingerprint.g.dart';

@JsonSerializable()
class Fingerprint {
  Fingerprint({
    required this.comparePercentPronunciation,
    required this.comparePercentPitch,
    required this.comparePercentEnergy,
    required this.comparePercentBreath,
    required this.pronunciationCompResultId,
    required this.breathCompResultId,
    required this.pitchCompResultId,
    required this.energyCompResultId,
    required this.audioSampleRefId,
    required this.audioSampleTstId,
    required this.error,
    required this.fingerprintDataJoinedSegments34530eeb,
    required this.xpAdd,
  }) {
    pronunciationSeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Pronunciation similarity',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.combinedPronunciation,
        dataSource:
            fingerprintDataJoinedSegments34530eeb.pronunciationE1cbebc6.frames,
      ),
    ];

    energySeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Energy',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.positiveEnergy,
        dataSource:
            fingerprintDataJoinedSegments34530eeb.prosodyC7f1eb37.frames,
      ),
    ];

    pitchSeries = <LineSeries<Frame, double>>[
      LineSeries<Frame, double>(
        name: 'Pitch',
        xValueMapper: (Frame frame, _) => frame.segmentStart,
        yValueMapper: (Frame frame, _) => frame.positivePitch,
        dataSource:
            fingerprintDataJoinedSegments34530eeb.prosodyC7f1eb37.frames,
      ),
    ];
  }

  factory Fingerprint.fromJson(Map<String, dynamic> json) {
    return _$FingerprintFromJson(json);
  }

  @JsonKey(name: 'ComparePercentPronunciation', defaultValue: 0)
  final double comparePercentPronunciation;
  @JsonKey(name: 'ComparePercentPitch', defaultValue: 0)
  final double comparePercentPitch;
  @JsonKey(name: 'ComparePercentEnergy', defaultValue: 0)
  final double comparePercentEnergy;
  @JsonKey(name: 'ComparePercentBreath', defaultValue: 0)
  final double comparePercentBreath;

  @JsonKey(name: 'PronunciationCompResultID')
  String pronunciationCompResultId;
  @JsonKey(name: 'BreathCompResultID')
  String breathCompResultId;
  @JsonKey(name: 'PitchCompResultID')
  String pitchCompResultId;
  @JsonKey(name: 'EnergyCompResultID')
  String energyCompResultId;
  @JsonKey(name: 'AudioSampleRefID')
  String audioSampleRefId;
  @JsonKey(name: 'AudioSampleTstID')
  String audioSampleTstId;
  String error;
  @JsonKey(name: 'FingerprintDataJoinedSegments34530eeb')
  FingerprintDataJoinedSegments34530eeb fingerprintDataJoinedSegments34530eeb;
  @JsonKey(name: 'XPAdd')
  final int? xpAdd;

  Map<String, dynamic> toJson() => _$FingerprintToJson(this);

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> pronunciationSeries;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> energySeries;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late final List<LineSeries<Frame, double>> pitchSeries;
}
