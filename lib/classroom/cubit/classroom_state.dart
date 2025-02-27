part of 'classroom_cubit.dart';

class ClassroomState extends Equatable {
  const ClassroomState({
    this.uiLoading = true,
    this.classrooms = const [],
    this.current = const [],
    this.invitations = const [],
    this.rejected = const [],
    this.classroomTicketToken,
    this.isClassroomUpdating = false,
    this.newClassroomCreating = false,
    this.newClassroomName = '',
    this.newClassroomId,
    this.canJoin = false,
  });

  final bool uiLoading;
  final List<ClassroomObject> classrooms;
  final List<ClassroomObject> current;
  final List<ClassroomObject> invitations;
  final List<ClassroomObject> rejected;
  final String? classroomTicketToken;
  final bool isClassroomUpdating;
  final bool newClassroomCreating;
  final String newClassroomName;
  final String? newClassroomId;
  final bool canJoin;

  ClassroomState copyWith({
    bool? uiLoading,
    List<ClassroomObject>? classrooms,
    List<ClassroomObject>? current,
    List<ClassroomObject>? invitations,
    List<ClassroomObject>? rejected,
    String? classroomTicketToken,
    bool? isClassroomUpdating,
    bool? newClassroomCreating,
    String? newClassroomName,
    String? newClassroomId,
    bool? canJoin,
  }) {
    return ClassroomState(
      uiLoading: uiLoading ?? this.uiLoading,
      classrooms: classrooms ?? this.classrooms,
      current: current ?? this.current,
      invitations: invitations ?? this.invitations,
      rejected: rejected ?? this.rejected,
      classroomTicketToken: classroomTicketToken ?? this.classroomTicketToken,
      isClassroomUpdating: isClassroomUpdating ?? this.isClassroomUpdating,
      newClassroomCreating: newClassroomCreating ?? this.newClassroomCreating,
      newClassroomName: newClassroomName ?? this.newClassroomName,
      newClassroomId: newClassroomId ?? this.newClassroomId,
      canJoin: canJoin ?? this.canJoin,
    );
  }

  @override
  List<Object?> get props => [
        uiLoading,
        classrooms.length,
        current.length,
        invitations.length,
        rejected.length,
        classroomTicketToken,
        isClassroomUpdating,
        newClassroomCreating,
        newClassroomName,
        newClassroomId,
        canJoin,
      ];
}
