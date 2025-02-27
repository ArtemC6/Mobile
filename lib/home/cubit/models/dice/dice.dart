import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voccent/http/response_data.dart';

part 'dice.g.dart';

@JsonSerializable()
class Dice {
  Dice({
    this.id,
    this.type,
  });

  factory Dice.fromJson(Map<String, dynamic> json) => _$DiceFromJson(json);
  @JsonKey(name: 'ID')
  String? id;
  @JsonKey(name: 'Type')
  String? type;

  @override
  String toString() {
    return 'Datum(id: $id, type: $type, )';
  }

  Map<String, dynamic> toJson() => _$DiceToJson(this);

  Dice copyWith({
    String? id,
    String? type,
  }) {
    return Dice(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  static Future<(String? diceId, String? diceType)> fetchDice(
    Client client,
  ) async {
    final queryParameters = <String, dynamic>{
      'trueRandom': 'true',
      'profileLanguages': 'true',
      'limit': '1',
    };

    const uriString = 'api/v1/search/feed';

    final uri = Uri.parse(uriString).replace(queryParameters: queryParameters);
    final response = await client.get(uri).listData();
    final dice = response
        .map(
          (dynamic e) => Dice.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    return (dice[0].id, dice[0].type);
  }
}
