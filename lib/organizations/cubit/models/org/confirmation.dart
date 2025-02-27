class Confirmation {
  Confirmation({
    this.id,
    this.createdat,
    this.objectId,
    this.objectName,
    this.sharedWith,
    this.sharedWithName,
    this.sharedWithEmail,
    this.type,
    this.status,
    this.permissions,
    this.permissionId,
  });

  factory Confirmation.fromJson(Map<String, dynamic> json) => Confirmation(
        id: json['ID'] as String?,
        createdat: json['createdat'] == null
            ? null
            : DateTime.parse(json['createdat'] as String),
        objectId: json['ObjectID'] as String?,
        objectName: json['ObjectName'] as String?,
        sharedWith: json['SharedWith'] as String?,
        sharedWithName: json['SharedWithName'] as String?,
        sharedWithEmail: json['SharedWithEmail'] as String?,
        type: json['Type'] as String?,
        status: json['Status'] as String?,
        permissions: (json['Permissions'] as List<dynamic>?)?.cast<String>(),
        permissionId: json['PermissionID'] as String?,
      );
  String? id;
  DateTime? createdat;
  String? objectId;
  String? objectName;
  String? sharedWith;
  String? sharedWithName;
  String? sharedWithEmail;
  String? type;
  String? status;
  List<String>? permissions;
  String? permissionId;

  Map<String, dynamic> toJson() => {
        'ID': id,
        'createdat': createdat?.toIso8601String(),
        'ObjectID': objectId,
        'ObjectName': objectName,
        'SharedWith': sharedWith,
        'SharedWithName': sharedWithName,
        'SharedWithEmail': sharedWithEmail,
        'Type': type,
        'Status': status,
        'Permissions': permissions,
        'PermissionID': permissionId,
      };
}
