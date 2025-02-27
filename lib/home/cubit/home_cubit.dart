import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/home/cubit/models/user/user_language.dart';
import 'package:voccent/http/response_data.dart';
import 'package:voccent/updater_service/updater_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._storage,
    this._updaterService,
  ) : super(const HomeState()) {
    _updateUserSubscription = _updaterService.userUpdate.listen(fetchUser);
  }

  final SharedPreferences _storage;
  final UpdaterService _updaterService;

  StreamSubscription<Object?>? _updateUserSubscription;

  Future<User> fetchUser(
    Client client,
  ) async {
    log('Fetching /api/v1/user', name: 'HomeCubit');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance
          .log('HomeCubit: Fetching /api/v1/user');
    }

    final user = User.fromJson(
      await client.get(Uri.parse('/api/v1/user')).mapData(),
    );
    if (user.currentlang?.isEmpty ?? true) {
      emit(
        state.copyWith(
          user: user.copyWith(
            currentlang: [
              UserLanguage(
                id: Dictionary.platformLanguage().id,
                name: Dictionary.platformLanguage().name ?? 'c1ef00fe',
              ),
            ],
          ),
          roleIsSystem: _storage.getBool('RoleIsSystem'),
        ),
      );

      final reqBody = <String, dynamic>{
        'firstname': state.user.firstname,
        'lastname': state.user.lastname,
        'username': state.user.username,
        'CurrentLang': state.user.currentlang,
        'WorkLang': state.user.worklang,
      };
      await client.patch(
        Uri.parse(
          '/api/v1/user/userid/${state.user.id}',
        ),
        body: json.encode(reqBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
    } else {
      emit(
        state.copyWith(
          user: user.copyWith(
            currentlang: user.currentlang?.map((cl) {
              final l = Dictionary.languages.firstWhere((l) => l.id == cl.id);
              return UserLanguage(id: cl.id, name: l.name ?? 'c1ef00fe');
            }).toList(),
          ),
          roleIsSystem: _storage.getBool('RoleIsSystem'),
        ),
      );
    }

    _updaterService.generateSystemNotificationToken(user);
    if (user.organizationId == null && user.focusOrganizationID == null) {
      emit(
        state.copyWith(
          pictureId: '',
        ),
      );
    } else if (user.organizationId != null) {
      emit(
        state.copyWith(
          pictureId: user.organizationId,
        ),
      );
    } else if (user.focusOrganizationID != null) {
      emit(
        state.copyWith(
          pictureId: user.focusOrganizationID,
        ),
      );
    }

    if (user.focusOrganizationID != null) {
      final uri =
          '/api/v1/classroom/user?organizationID=${user.focusOrganizationID}&statuses=resolved,confirmed';

      final response = await client.get(
        Uri.parse(uri),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final data = jsonData['data'];
      if (data is List && data.isNotEmpty) {
        final firstClassroom = (data[0] as Map<String, dynamic>)['Classroom']
            as Map<String, dynamic>;
        final classroomsId = firstClassroom['ID'] as String? ?? '';
        final myClassroomsName = firstClassroom['Name'] as String? ?? '';

        emit(
          state.copyWith(
            classroomFocusId: classroomsId,
            classroomFocusName: myClassroomsName,
          ),
        );
      }
    } else if (user.focusOrganizationID == null) {
      emit(
        state.copyWith(
          classroomFocusId: '',
          classroomFocusName: '',
        ),
      );
    }

    if (!kDebugMode) {
      final smartlook = Smartlook.instance;
      await smartlook.user.setIdentifier(user.id ?? '');
      await smartlook.user.setName(user.username ?? '');
      await smartlook.user.setEmail(user.credId ?? '');
    }

    if (!kIsWeb) {
      final smartlook = Smartlook.instance;
      final sessionUrlWithTimestamp =
          await smartlook.user.session.getUrlWithTimeStamp();

      if (sessionUrlWithTimestamp != null) {
        await FirebaseCrashlytics.instance
            .setCustomKey('smartlook_session_url', sessionUrlWithTimestamp);
      }

      await FirebaseCrashlytics.instance.setUserIdentifier(user.credId ?? '');
    }
    await FirebaseAnalytics.instance.setUserId(id: user.credId);

    unawaited(
      FirebaseAnalytics.instance.setUserProperty(
        name: 'app_language',
        value: kIsWeb ? 'unsupported-dd43f6cd' : Platform.localeName,
      ),
    );

    return state.user;
  }

  void updateXp(int xpTotal, int xpFactor) => emit(
        state.copyWith(
          user: state.user.copyWith(
            xpTotal: xpTotal,
            xpFactorCurrent: xpFactor,
          ),
        ),
      );

  List<UserLanguage> userLanguages() => state.user.worklang ?? <UserLanguage>[];

  void openContent() => emit(
        state.copyWith(
          openContent: !state.openContent,
        ),
      );

  Future<void> requestNotification(Client client) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationData', DateTime.now().toString());

    await client.get(
      Uri.parse(
        'api/v1/chokmah',
      ),
    );
  }

  void refresh() {
    emit(
      state.copyWith(
        refresh: !state.refresh,
      ),
    );
  }

  @override
  Future<void> close() {
    _updateUserSubscription?.cancel();
    return super.close();
  }
}
