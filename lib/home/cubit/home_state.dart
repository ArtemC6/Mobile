part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.user = const User(),
    this.organizationID = '',
    this.pictureId = '',
    this.classroomFocusId = '',
    this.classroomFocusName = '',
    this.refresh = false,
    this.roleIsSystem = false,
    this.openContent = true,
  });

  HomeState copyWith({
    User? user,
    String? organizationID,
    String? pictureId,
    String? classroomFocusId,
    String? classroomFocusName,
    bool? refresh,
    bool? roleIsSystem,
    bool? openContent,
  }) {
    return HomeState(
      user: user ?? this.user,
      organizationID: organizationID ?? this.organizationID,
      pictureId: pictureId ?? this.pictureId,
      classroomFocusId: classroomFocusId ?? this.classroomFocusId,
      classroomFocusName: classroomFocusName ?? this.classroomFocusName,
      refresh: refresh ?? this.refresh,
      roleIsSystem: roleIsSystem ?? this.roleIsSystem,
      openContent: openContent ?? this.openContent,
    );
  }

  final User user;
  final String organizationID;
  final String pictureId;
  final String classroomFocusId;
  final String classroomFocusName;
  final bool refresh;
  final bool roleIsSystem;
  final bool openContent;

  @override
  List<Object> get props => [
        user,
        organizationID,
        pictureId,
        classroomFocusId,
        classroomFocusName,
        refresh,
        roleIsSystem,
        openContent,
      ];
}
