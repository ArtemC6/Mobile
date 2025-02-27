class Organization {
  Organization({this.id, this.createdat, this.createdby, this.name});

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['ID'] as String?,
        createdat: json['createdat'] == null
            ? null
            : DateTime.parse(json['createdat'] as String),
        createdby: json['createdby'] as String?,
        name: json['Name'] as String?,
      );
  String? id;
  DateTime? createdat;
  String? createdby;
  String? name;

  Map<String, dynamic> toJson() => {
        'ID': id,
        'createdat': createdat?.toIso8601String(),
        'createdby': createdby,
        'Name': name,
      };
}
