import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/dictionary/cubit/models/language/language.dart';
import 'package:voccent/home/cubit/models/user/asset.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/http/response_data.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._client,
    this._languages,
    this._sharedPreferences,
  ) : super(
          const ProfileState(
            showLoading: false,
            uiLoading: false,
            firstName: null,
            lastName: null,
            username: null,
            user: User(),
            errorMessage: '',
            currentlang: [],
            worklang: [],
            avatarData: '',
          ),
        );

  final Client _client;
  final List<Language> _languages;
  final SharedPreferences _sharedPreferences;

  Future<void> fetchData(User user) async {
    final organizationID = _sharedPreferences.getString('OrganizationID');
    final roleIsSystem = _sharedPreferences.getBool('roleIsSystem');

    emit(
      state.copyWith(
        user: user,
        organizationID: organizationID,
        roleIsSystem: roleIsSystem,
        firstName: user.firstname,
        lastName: user.lastname,
        username: user.username,
        currentlang: user.currentlang
            ?.map((ul) => _languages.firstWhere((dl) => dl.id == ul.id))
            .toList(),
        worklang: user.worklang
            ?.map((ul) => _languages.firstWhere((dl) => dl.id == ul.id))
            .toList(),
        uiLoading: false,
        avatarData: user.asset?.userAvatar?.first,
      ),
    );
  }

  Future<void> submitEditing() async {
    emit(state.copyWith(showLoading: true, errorMessage: ''));

    final userLanguages =
        state.worklang.map((e) => e.toUserLanguage()).toList();

    final reqBody = <String, dynamic>{
      'firstname': state.firstName,
      'lastname': state.lastName,
      'username': state.username,
      'CurrentLang': state.currentlang.map((e) => e.toUserLanguage()).toList(),
      'WorkLang': userLanguages,
    };

    await _client.patch(
      Uri.parse(
        '/api/v1/user/userid/${state.user.id}',
      ),
      body: json.encode(reqBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    await _sharedPreferences.setString(
      'search_language_filter',
      json.encode(userLanguages),
    );

    if (!isClosed) {
      emit(state.copyWith(showLoading: false));
    }

    await Intercom.instance.updateUser(
      name: '${state.user.firstname ?? ''} ${state.user.lastname ?? ''}',
      userId: state.user.username,
    );
  }

  Future<void> _requestPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      return;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> pickImage(String objectId) async {
    try {
      await _requestPermission();
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
      );
      if (pickedFile != null) {
        final uploadAssetRequest = MultipartRequest(
          'POST',
          Uri.parse('/api/v1/asset'),
        );

        uploadAssetRequest.fields.addAll({
          'object_id': objectId,
          'file_type': 'user_avatar',
        });
        final fileBytes = await pickedFile.readAsBytes();
        final file = MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: 'user_avatar.jpg',
          contentType: MediaType.parse('image/jpg'),
        );
        uploadAssetRequest.files.add(file);
        final response =
            await Response.fromStream(await _client.send(uploadAssetRequest));
        final imageData = response.mapData()['file_object_id'] as String;

        changeAvatar(imageData);
      }
    } catch (e) {
      throw Exception('Update avatar failed');
    }
  }

  void changeAvatar(String avatarData) {
    emit(
      state.copyWith(
        avatarData: avatarData,
        isAvatarChanged: true,
      ),
    );
  }

  void changeFirstName(String value) {
    emit(state.copyWith(firstName: value));
  }

  void changeLastName(String value) {
    emit(state.copyWith(lastName: value));
  }

  Future<void> changeUsername(String value) async {
    emit(state.copyWith(username: value));

    final pattern = RegExp(r'^[a-zA-Z\d._-]{5,20}$');
    if (!pattern.hasMatch(value)) {
      emit(
        state.copyWith(
          isUsernameAvailable: false,
        ),
      );

      return;
    }
    final response = await _client
        .get(Uri.parse('/api/v1/user/available/$value'))
        .boolData();
    if (value != state.username) {
      return;
    }

    emit(
      state.copyWith(
        isUsernameAvailable: response,
      ),
    );
  }

  void setLanguagesICan(Language language) {
    final languagesICan = List<Language>.from(state.currentlang);

    if (languagesICan.any((e) => e.id == language.id)) {
      languagesICan.removeWhere((e) => e.id == language.id);
    } else {
      languagesICan.add(language);
    }

    emit(
      state.copyWith(currentlang: languagesICan),
    );
  }

  void setLanguagesIWant(Language language) {
    final languagesIWant = List<Language>.from(state.worklang);

    if (languagesIWant.any((e) => e.id == language.id)) {
      languagesIWant.removeWhere((e) => e.id == language.id);
    } else {
      languagesIWant.add(language);
    }

    emit(
      state.copyWith(worklang: languagesIWant),
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(showLoading: true));

    await _client.delete(
      Uri.parse('api/v1/user'),
      body: '{}',
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
  }
}
