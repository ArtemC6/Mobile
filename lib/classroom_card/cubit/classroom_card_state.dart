part of 'classroom_card_cubit.dart';

class ClassroomCardState extends Equatable {
  const ClassroomCardState({
    this.loaded = false,
    this.loading = false,
    this.error,
    this.user = const User(),
    this.classroom,
    this.classroomUserTicketToken,
    this.classroomId,
    this.code,
    this.enterCode = '',
    this.isCodeValid = true,
    this.isLoadingJoinCode = false,
  });

  final bool loaded;
  final bool loading;
  final String? error;
  final User user;
  final ClassroomCardModel? classroom;
  final String? classroomUserTicketToken;
  final String? classroomId;
  final String? code;
  final String enterCode;
  final bool isCodeValid;
  final bool isLoadingJoinCode;

  @override
  List<Object?> get props => [
        loaded,
        loading,
        error,
        user,
        classroom,
        classroomUserTicketToken,
        classroomId,
        code,
        enterCode,
        isCodeValid,
        isLoadingJoinCode,
      ];

  ClassroomCardState copyWith({
    bool? loaded,
    bool? loading,
    String? error,
    User? user,
    ClassroomCardModel? classroom,
    String? classroomUserTicketToken,
    String? classroomId,
    String? code,
    String? enterCode,
    bool? isCodeValid,
    bool? isLoadingJoinCode,
  }) {
    return ClassroomCardState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      user: user ?? this.user,
      classroom: classroom ?? this.classroom,
      classroomUserTicketToken:
          classroomUserTicketToken ?? this.classroomUserTicketToken,
      classroomId: classroomId ?? this.classroomId,
      code: code ?? this.code,
      enterCode: enterCode ?? this.enterCode,
      isCodeValid: isCodeValid ?? this.isCodeValid,
      isLoadingJoinCode: isLoadingJoinCode ?? this.isLoadingJoinCode,
    );
  }

  ClassroomCardModel copyClassroomWith({
    ClassroomCardClassroomModel? classroom,
    List<String>? languageIds,
    ClassroomCardConfirmationModel? confirmation,
    List<ClassroomCardPlanModel>? currentPlans,
  }) {
    return ClassroomCardModel(
      classroom: classroom ?? this.classroom?.classroom,
      languageIds: languageIds ?? this.classroom?.languageIds,
      confirmation: confirmation ?? this.classroom?.confirmation,
      currentPlans: currentPlans ?? this.classroom?.currentPlans,
    );
  }
}
