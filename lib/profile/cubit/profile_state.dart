part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    required this.showLoading,
    required this.uiLoading,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.user,
    required this.errorMessage,
    required this.currentlang,
    required this.worklang,
    required this.avatarData,
    this.isUsernameAvailable = true,
    this.asset,
    this.organizationID = '',
    this.isAvatarChanged = false,
    this.roleIsSystem = false,
  });

  final bool showLoading;
  final bool uiLoading;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String errorMessage;
  final User user;
  final List<Language> currentlang;
  final List<Language> worklang;
  final bool isUsernameAvailable;
  final Asset? asset;
  final String avatarData;
  final String organizationID;
  final bool isAvatarChanged;
  final bool roleIsSystem;

  ProfileState copyWith({
    bool? showLoading,
    bool? uiLoading,
    String? firstName,
    String? lastName,
    String? username,
    User? user,
    String? errorMessage,
    List<Language>? currentlang,
    List<Language>? worklang,
    bool? isUsernameAvailable,
    Asset? asset,
    String? avatarData,
    String? organizationID,
    bool? isAvatarChanged,
    bool? roleIsSystem,
  }) {
    return ProfileState(
      showLoading: showLoading ?? this.showLoading,
      uiLoading: uiLoading ?? this.uiLoading,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      currentlang: currentlang ?? this.currentlang,
      worklang: worklang ?? this.worklang,
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      asset: asset ?? this.asset,
      avatarData: avatarData ?? this.avatarData,
      organizationID: organizationID ?? this.organizationID,
      isAvatarChanged: isAvatarChanged ?? this.isAvatarChanged,
      roleIsSystem: roleIsSystem ?? this.roleIsSystem,
    );
  }

  @override
  List<Object?> get props => [
        showLoading,
        uiLoading,
        firstName,
        lastName,
        username,
        user.id,
        errorMessage,
        currentlang,
        worklang,
        isUsernameAvailable,
        asset,
        avatarData,
        isAvatarChanged,
        organizationID,
        roleIsSystem,
      ];
}
