// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/themes/themes.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/profile/cubit/profile_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/language_selector/language_selector.dart';
import 'package:voccent/widgets/loading_effect.dart';

class ProfileEditorView extends StatelessWidget {
  const ProfileEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => ProfileCubit(
        context.read<UserScopeClient>(),
        Dictionary.languages,
        context.read<SharedPreferences>(),
      )..fetchData(context.read<HomeCubit>().state.user),
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) => current.user != previous.user,
        listener: (context, state) =>
            context.read<ProfileCubit>().fetchData(state.user),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage ||
              previous.isAvatarChanged != current.isAvatarChanged,
          listener: (context, state) async {
            await context
                .read<HomeCubit>()
                .fetchUser(context.read<UserScopeClient>());

            if (state.errorMessage != '') {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('46a29365: ${state.errorMessage}'),
                  ),
                );
            }
          },
          builder: _build,
        ),
      ),
    );
  }

  Widget _build(BuildContext context, ProfileState state) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final mTheme = theme.colorScheme;
    final user = state.user;
    final validCharacters =
        '${S.current.validCharacters}: A-Z, a-z, 0-9, . ,  - ,  _';

    if (state.uiLoading) {
      return Scaffold(
        body: Padding(
          padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
          child: LoadingEffect.getSearchLoadingScreen(context, theme),
        ),
      );
    } else {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 74,
                            sigmaY: 74,
                          ),
                          child: Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(.8),
                          ),
                        ),
                      ),
                      _AnimationBackground(isDarkTheme: isDarkTheme),
                    ],
                  ),
                ),
              ),
            ],
          ),
          PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (user.id == null ||
                  state.showLoading ||
                  !state.isUsernameAvailable) {
                Navigator.of(context).pop();
              } else {
                final homeCubit = context.read<HomeCubit>();
                final userScopeClient = context.read<UserScopeClient>();
                await context.read<ProfileCubit>().submitEditing().then(
                  (_) {
                    homeCubit.fetchUser(userScopeClient);
                    Navigator.of(context).pop();
                  },
                );
              }
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: FxText.titleMedium(
                  S.current.profileSettings.toUpperCase(),
                  fontWeight: 600,
                  textScaleFactor: 1.2257,
                  color: mTheme.primary,
                ),
                elevation: 0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async {
                    if (user.id == null ||
                        state.showLoading ||
                        !state.isUsernameAvailable) {
                      Navigator.of(context).pop();
                    } else {
                      final homeCubit = context.read<HomeCubit>();
                      final userScopeClient = context.read<UserScopeClient>();
                      await context.read<ProfileCubit>().submitEditing().then(
                        (_) {
                          homeCubit.fetchUser(userScopeClient);
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    size: 25,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                actions: [
                  if (user.id == null || state.showLoading)
                    Container()
                  else
                    IconButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (notThisContext) => Platform.isIOS
                            ? _deleteAccountIosDialog(context)
                            : _deleteAccountDialog(context),
                      ),
                      icon: Icon(
                        FeatherIcons.trash2,
                        color: mTheme.error,
                      ),
                    ),
                ],
              ),
              body: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 550),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Center(
                              child: FxContainer(
                                color: Colors.transparent,
                                paddingAll: 0,
                                bordered: true,
                                borderColor: mTheme.primary,
                                borderRadiusAll: 100,
                                height: 120,
                                width: 120,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                      child: (user.asset?.userAvatar?.first ==
                                              null)
                                          ? Image.asset(
                                              'assets/images/avatar_place.png',
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              //ignore: lines_longer_than_80_chars
                                              '${context.read<ServerAddress>().httpUri}'
                                              '/api/v1/asset/file/user_avatar/'
                                              '${state.avatarData}',
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) =>
                                                  Image.asset(
                                                'assets/images/avatar_place.png',
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          context
                                              .read<ProfileCubit>()
                                              .pickImage(state.user.id!);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: mTheme.onPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: mTheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                size: 20,
                                                Icons.add,
                                                color: mTheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FxSpacing.height(30),
                            FxContainer(
                              color: mTheme.onPrimary.withOpacity(0.75),
                              child: Column(
                                children: [
                                  TextFormFieldWidget(
                                    initialValue: user.firstname.toString(),
                                    hintText: S.current.profileFirstName,
                                    onChanged: (value) => context
                                        .read<ProfileCubit>()
                                        .changeFirstName(value),
                                  ),
                                  FxSpacing.height(8),
                                  TextFormFieldWidget(
                                    initialValue: user.lastname.toString(),
                                    hintText: S.current.profileLastName,
                                    onChanged: (value) => context
                                        .read<ProfileCubit>()
                                        .changeLastName(value),
                                  ),
                                ],
                              ),
                            ),
                            FxSpacing.height(8),
                            FxContainer(
                              color: mTheme.onPrimary.withOpacity(0.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodyMedium(
                                      S.current.profileUserName,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                  FxSpacing.height(8),
                                  TextFormFieldWidget(
                                    user: user,
                                    initialValue: user.username.toString(),
                                    hintText: S.current.profileUserName,
                                    onChanged: (value) => context
                                        .read<ProfileCubit>()
                                        .changeUsername(value),
                                    suffixIcon: state.isUsernameAvailable
                                        ? null
                                        : const Icon(
                                            FeatherIcons.userX,
                                            color: Colors.red,
                                            size: 15,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodySmall(
                                      validCharacters,
                                      fontWeight: 300,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodySmall(
                                      S.current.minimum5Characters,
                                      fontWeight: 300,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FxSpacing.height(8),
                            FxContainer(
                              color: mTheme.onPrimary.withOpacity(0.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodyMedium(
                                      S.current.languagesYouSpeak,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                  FxSpacing.height(8),
                                  LanguageSelector(
                                    callback: context
                                        .read<ProfileCubit>()
                                        .setLanguagesICan,
                                    languagesList: Dictionary.languages,
                                    languagesSelected: context
                                        .read<ProfileCubit>()
                                        .state
                                        .currentlang,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodySmall(
                                      S.current.filterSelectLanguages,
                                      fontWeight: 300,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FxSpacing.height(8),
                            FxContainer(
                              color: mTheme.onPrimary.withOpacity(0.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodyMedium(
                                      S.current.languagesToLearn,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                  FxSpacing.height(8),
                                  LanguageSelector(
                                    callback: context
                                        .read<ProfileCubit>()
                                        .setLanguagesIWant,
                                    languagesList: Dictionary.languages,
                                    languagesSelected: context
                                        .read<ProfileCubit>()
                                        .state
                                        .worklang,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: FxText.bodySmall(
                                      S.current.filterSelectLanguages,
                                      fontWeight: 300,
                                      color: mTheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _deleteAccountDialog(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: FxSpacing.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child:
                        FxText.titleLarge('Account deletion', fontWeight: 600),
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              margin: FxSpacing.only(top: 8),
              child: RichText(
                text: TextSpan(
                  style: FxTextStyle.titleSmall(
                    fontWeight: 600,
                    letterSpacing: 0.2,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'This operation will:\n'
                          'Delete all audio files you created '
                          'as an author and marked private;\n'
                          'Delete all your payment information;\n'
                          'Delete all your logs and statistics;\n'
                          'Delete all your chat history.',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: FxSpacing.top(24),
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FxButton.text(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: FxText.bodyMedium(
                      S.current.genericCancel,
                      fontWeight: 600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  FxButton(
                    backgroundColor: theme.colorScheme.primary,
                    borderRadiusAll: 4,
                    elevation: 0,
                    onPressed: () {
                      final profile = context.read<ProfileCubit>();
                      final auth = context.read<AuthCubit>();
                      final router = GoRouter.of(context);
                      profile.deleteAccount();

                      Navigator.pop(context);
                      router.go('/');

                      auth.logout();
                    },
                    child: FxText.bodyMedium(
                      'Delete',
                      fontWeight: 600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccountIosDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Account deletion'),
      content: const Text(
        'This operation will:\n'
        'Delete all audio files you created '
        'as an author and marked private;\n'
        'Delete all your payment information;\n'
        'Delete all your logs and statistics;\n'
        'Delete all your chat history.',
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.current.genericCancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            final profile = context.read<ProfileCubit>();
            final auth = context.read<AuthCubit>();
            final router = GoRouter.of(context);
            profile.deleteAccount();

            Navigator.pop(context);
            router.go('/');

            auth.logout();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    required this.initialValue,
    required this.hintText,
    super.key,
    this.onChanged,
    this.user,
    this.helperText,
    this.suffixIcon,
  });

  final String initialValue;
  final void Function(String)? onChanged;
  final String hintText;
  final User? user;
  final String? helperText;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return TextFormField(
      autocorrect: false,
      style: FxTextStyle.titleMedium(
        color: mTheme.onSecondary,
      ),
      cursorColor: mTheme.onSecondary,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: Colors.transparent,
        isDense: true,
        labelStyle: FxTextStyle.bodyMedium(),
        hintText: hintText,
        hintStyle: FxTextStyle.labelLarge(
          letterSpacing: 0.1,
          color: theme.colorScheme.onBackground,
        ),
        helperText: helperText,
        suffixIcon: suffixIcon,
        border: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: mTheme.onSecondary.withOpacity(0.45),
            width: 0.8,
          ),
        ),
        enabledBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: mTheme.onSecondary.withOpacity(0.45),
            width: 0.8,
          ),
        ),
        focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: mTheme.onSecondary.withOpacity(0.45),
            width: 0.8,
          ),
        ),
        contentPadding: FxSpacing.symmetric(vertical: 12, horizontal: 8),
      ),
      initialValue: initialValue,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
    );
  }
}

class _AnimationBackground extends StatefulWidget {
  const _AnimationBackground({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  _AnimationBackgroundState createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<_AnimationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 11).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: widget.isDarkTheme ? Colors.black : Colors.white,
      end: widget.isDarkTheme ? Colors.black : Colors.white,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.transparent,
                _colorAnimation.value ?? Colors.transparent,
              ],
              stops: const [0.06, 1],
              radius: 1.14 + _animation.value,
            ),
          ),
        ),
      );
}
