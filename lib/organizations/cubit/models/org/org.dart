import 'package:voccent/organizations/cubit/models/org/confirmation.dart';
import 'package:voccent/organizations/cubit/models/org/organization.dart';

class Org {
  Org({this.organization, this.confirmations});

  factory Org.fromJson(Map<String, dynamic> json) => Org(
        organization: json['Organization'] == null
            ? null
            : Organization.fromJson(
                json['Organization'] as Map<String, dynamic>,
              ),
        confirmations: (json['Confirmations'] as List<dynamic>?)
            ?.map((e) => Confirmation.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  Organization? organization;
  List<Confirmation>? confirmations;

  Map<String, dynamic> toJson() => {
        'Organization': organization?.toJson(),
        'Confirmations': confirmations?.map((e) => e.toJson()).toList(),
      };
}
