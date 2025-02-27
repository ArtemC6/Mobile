part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.userToken,
    required this.userStatus,
    this.isFirstRun = false,
    this.qrCode = '',
  });

  final UserStatus userStatus;
  final UserToken userToken;
  final bool isFirstRun;
  final String qrCode;

  AuthState copyWith({
    UserToken? userToken,
    UserStatus? userStatus,
    bool? isFirstRun,
    String? qrCode,
  }) {
    return AuthState(
      userToken: userToken ?? this.userToken,
      userStatus: userStatus ?? this.userStatus,
      isFirstRun: isFirstRun ?? this.isFirstRun,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  @override
  List<Object> get props => [userToken, userStatus, isFirstRun, qrCode];
}
