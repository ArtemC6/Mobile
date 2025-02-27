part of 'about_cubit.dart';

class AboutState extends Equatable {
  const AboutState({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
    this.pushyCreds,
    this.storiesStatus,
    this.chatStatus,
    this.challengesStatus,
    this.playlistsStatus,
  });

  final String? appName;
  final String? packageName;
  final String? version;
  final String? buildNumber;
  final String? pushyCreds;
  final bool? storiesStatus;
  final bool? chatStatus;
  final bool? challengesStatus;
  final bool? playlistsStatus;

  AboutState copyWith({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
    String? pushyCreds,
    bool? storiesStatus,
    bool? chatStatus,
    bool? challengesStatus,
    bool? playlistsStatus,
  }) {
    return AboutState(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      pushyCreds: pushyCreds ?? this.pushyCreds,
      storiesStatus: storiesStatus ?? this.storiesStatus,
      chatStatus: chatStatus ?? this.chatStatus,
      challengesStatus: challengesStatus ?? this.challengesStatus,
      playlistsStatus: playlistsStatus ?? this.playlistsStatus,
    );
  }

  @override
  List<Object?> get props => [
        appName,
        packageName,
        version,
        buildNumber,
        pushyCreds,
        storiesStatus,
        chatStatus,
        challengesStatus,
        playlistsStatus,
      ];
}
