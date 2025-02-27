import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:voccent/auth/cubit/user_status.dart';
import 'package:voccent/authentication_repository/authentication_repository.dart';
import 'package:voccent/authentication_repository/models/user.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/http/account_deleted_exception.dart';
import 'package:voccent/http/client_token.dart';
import 'package:voccent/http/invalid_token_exception.dart';
import 'package:voccent/http/null_token.dart';
import 'package:voccent/http/user_token.dart';
import 'package:voccent/http/username_is_taken_exception.dart';
import 'package:voccent/http/username_required_exception.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authenticationRepository,
    this._clientToken,
    this._server,
    this._storage,
    this._socket,
  ) : super(
          AuthState(
            userToken: NullToken(),
            userStatus: UserStatus.undefined,
          ),
        );

  static const _fbTokenKey = 'VOC_FIREBASE_TOKEN';

  void restoreUserFromStorage() {
    if (_storage.containsKey(_fbTokenKey)) {
      emit(
        state.copyWith(
          userStatus: UserStatus.authenticated,
          userToken: UserToken(
            _server.httpUri,
            _storage.getString(_fbTokenKey)!,
            _clientToken,
            _storage,
          ),
        ),
      );
    } else {
      _subscribeToFirebase();
    }
  }

  final WebSocket _socket;
  final ClientToken _clientToken;
  final AuthenticationRepository _authenticationRepository;
  final ServerAddress _server;
  final SharedPreferences _storage;
  StreamSubscription<FirebaseUser>? _userSubscription;
  final _lock = Lock();

  void _subscribeToFirebase() {
    _userSubscription ??= _authenticationRepository.user.listen(_onUserChanged);
  }

  Future<void> _clearAllTokens() async {
    await _clientToken.clear();
    await state.userToken.clear();
    await _storage.remove(_fbTokenKey);
  }

  Future<void> _onUserChanged(FirebaseUser user) async {
    final UserToken usrToken;

    if (user.isEmpty) {
      await _clearAllTokens();
      await _storage.clear(); // This also clears all the tokens
      usrToken = NullToken();
    } else {
      final fbToken = await user.firebaseIdToken() ?? '85759b7f';

      await _storage.setString(_fbTokenKey, fbToken);

      usrToken = UserToken(
        _server.httpUri,
        fbToken,
        _clientToken,
        _storage,
      );
    }

    emit(
      state.copyWith(
        userToken: usrToken,
        userStatus: await _userStatus(user, usrToken),
      ),
    );
  }

  Future<void> saveQrCode(
    String code,
  ) async {
    if (code.isNotEmpty) {
      emit(
        state.copyWith(
          qrCode: code,
        ),
      );
      await _storage.setString('joinCode', code);
    }
  }

  Future<void> updateUserToken(
    String username,
    List<Language> langsICan,
    List<Language> langsIWant,
    String code,
  ) async {
    emit(state.copyWith(userStatus: UserStatus.checkingUsername));

    final usrToken = state.userToken
      ..newUserSettings = {
        'Restoreuser': false,
        'Username': username,
        'CurrentLang': langsICan.map((e) => {'languageid': e.id}).toList(),
        'WorkLang': langsIWant.map((e) => {'languageid': e.id}).toList(),
      };

    final userStatus =
        await _userStatus(_authenticationRepository.currentUser, usrToken);

    emit(
      state.copyWith(
        userToken: usrToken,
        userStatus: userStatus,
        isFirstRun: code.isEmpty,
      ),
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => emit(
        state.copyWith(qrCode: ''),
      ),
    );
  }

  void didSeeOnboardingStory() {
    emit(
      state.copyWith(
        isFirstRun: false,
      ),
    );
  }

  Future<UserStatus> _userStatus(FirebaseUser user, UserToken token) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setUserIdentifier('');
    }

    if (user.isEmpty) {
      return UserStatus.unauthenticated;
    }

    try {
      await _lock.synchronized(token.value);
    } on UsernameIsTakenException {
      return UserStatus.usernameIsTaken;
    } on AccountDeletedException {
      return UserStatus.missingUsername;
    } on UsernameRequiredException {
      return UserStatus.missingUsername;
    } on InvalidTokenException {
      return UserStatus.unauthenticated;
    }

    return UserStatus.authenticated;
  }

  Future<void> logInWithApple() async {
    emit(state.copyWith(userStatus: UserStatus.authenticating));
    try {
      await _authenticationRepository.logInWithApple();
      unawaited(FirebaseAnalytics.instance.logLogin(loginMethod: 'Apple'));
    } catch (e) {
      if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        emit(state.copyWith(userStatus: UserStatus.submissionCanceled));
        return;
      }

      emit(
        state.copyWith(
          userStatus: UserStatus.submissionFailed,
        ),
      );

      rethrow;
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(userStatus: UserStatus.authenticating));
    try {
      await _authenticationRepository.logInWithGoogle();
      unawaited(FirebaseAnalytics.instance.logLogin(loginMethod: 'Google'));
    } on LogInWithGoogleFailure catch (e) {
      if (e.message.isEmpty) {
        emit(state.copyWith(userStatus: UserStatus.submissionCanceled));
        return;
      }

      emit(state.copyWith(userStatus: UserStatus.submissionFailed));
    } catch (e) {
      emit(
        state.copyWith(
          userStatus: UserStatus.submissionFailed,
        ),
      );

      rethrow;
    }
  }

  Future<void> logInWithMicrosoft() async {
    emit(state.copyWith(userStatus: UserStatus.authenticating));
    try {
      await _authenticationRepository.logInWithMicrosoft();
      unawaited(FirebaseAnalytics.instance.logLogin(loginMethod: 'Microsoft'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'web-context-canceled':
        case 'web-context-cancelled':
          emit(state.copyWith(userStatus: UserStatus.submissionCanceled));
          return;
        case 'invalid-credential':
          emit(state.copyWith(userStatus: UserStatus.submissionFailed));
          return;
      }

      emit(
        state.copyWith(
          userStatus: UserStatus.submissionFailed,
        ),
      );

      rethrow;
    } catch (_) {
      emit(
        state.copyWith(
          userStatus: UserStatus.submissionFailed,
        ),
      );

      rethrow;
    }
  }

  Future<void> logout() async {
    await _authenticationRepository.logOut();
    _subscribeToFirebase();
    await Intercom.instance.logout();
    _socket.send(<String, dynamic>{'Type': 'disconnect'});
    await Smartlook.instance.user.openNew();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
