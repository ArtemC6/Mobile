import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voccent/home/cubit/models/user/user.dart';

class UpdaterService {
  final _controllerRecentClassroomUpdate = PublishSubject<String>();
  final _controllerRecentItemAdded = PublishSubject<Object?>();
  final _controllerMyClassroomsFetch = PublishSubject<Object?>();
  final _controllerDailyProgress = PublishSubject<Object?>();
  final _controllerUpdateMembersOfClassroom = PublishSubject<Object?>();
  final _controllerUpdateUser = PublishSubject<Client>();
  final _controllerGenerateNotificationToken = PublishSubject<User>();
  final _controllerUpdatePlanProgress = PublishSubject<User>();

  /// Stream on adding a class to recently viewed.
  Stream<String> get recentClassroomUpdate =>
      _controllerRecentClassroomUpdate.stream;

  /// Stream on adding a item to recently viewed.
  Stream<Object?> get recentItemAdded => _controllerRecentItemAdded.stream;

  /// Stream for fetch my classrooms.
  Stream<Object?> get myClassroomsFetch => _controllerMyClassroomsFetch.stream;

  /// Stream for fetch daily progress.
  Stream<Object?> get dailyProgressFetch => _controllerDailyProgress.stream;

  /// Stream for update members of classroom.
  Stream<Object?> get classroomMembersUpdate =>
      _controllerUpdateMembersOfClassroom.stream;

  /// Stream for update User.
  Stream<Client> get userUpdate => _controllerUpdateUser.stream;

  /// Stream for generate systemNotificationTiketToken.
  Stream<User> get tokenGenerate => _controllerGenerateNotificationToken.stream;

  /// Stream for update plan progress.
  Stream<User> get planProgressUpdate => _controllerUpdatePlanProgress.stream;

  /// Event for adding a class to recently viewed.
  void updateRecentClassrooms(String classroomId) =>
      _controllerRecentClassroomUpdate.add(classroomId);

  /// Event for adding a class to recently viewed.
  void addItemToRecent(Object? object) =>
      _controllerRecentItemAdded.add(object);

  /// Event for fetch my classrooms.
  void fetchMyClassrooms(Object? object) =>
      _controllerMyClassroomsFetch.add(object);

  /// Event for fetch daily progress.
  void fetchDailyProgress(Object? object) =>
      _controllerDailyProgress.add(object);

  /// Event for update classroom.
  void updateMembersOfClassroom(Object? object) =>
      _controllerUpdateMembersOfClassroom.add(object);

  /// Event for update User.
  void updateUser(Client object) => _controllerUpdateUser.add(object);

  /// Event for generate systemNotificationTiketToken.
  void generateSystemNotificationToken(User user) =>
      _controllerGenerateNotificationToken.add(user);

  /// Event for update plan progress.
  void updatePlanProgress(User user) => _controllerUpdatePlanProgress.add(user);

  Future<void> dispose() async {
    await _controllerRecentClassroomUpdate.close();
    await _controllerRecentItemAdded.close();
    await _controllerMyClassroomsFetch.close();
    await _controllerDailyProgress.close();
    await _controllerUpdateMembersOfClassroom.close();
    await _controllerUpdateUser.close();
    await _controllerGenerateNotificationToken.close();
    await _controllerUpdatePlanProgress.close();
  }
}
