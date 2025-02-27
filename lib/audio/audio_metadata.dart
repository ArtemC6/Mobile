import 'dart:convert';

class AudioMetadata {
  AudioMetadata({this.volume});

  factory AudioMetadata.fromMap(Map<String, dynamic> data) => AudioMetadata(
        volume: data['Volume'] as int?,
      );

  /// `dart:convert`
  ///
  /// Parses the string and
  /// returns the resulting Json object as [AudioMetadata].
  factory AudioMetadata.fromJson(String? data) {
    return AudioMetadata.fromMap(
      json.decode(data ?? '{ }') as Map<String, dynamic>,
    );
  }
  int? volume;

  Map<String, dynamic> toMap() => {
        'Volume': volume,
      };

  /// `dart:convert`
  ///
  /// Converts [AudioMetadata] to a JSON string.
  String toJson() => json.encode(toMap());
}
