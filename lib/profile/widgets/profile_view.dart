import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/onboarding/i_want_to_speak_view.dart';
import 'package:voccent/profile/cubit/profile_cubit.dart';
import 'package:voccent/profile/widgets/preferences_view.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final mTheme = theme.colorScheme;

            if (state.uiLoading) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: FxText.titleMedium(
                    S.current.profileTabProfile.toUpperCase(),
                    fontWeight: 700,
                    textScaleFactor: 1.2257,
                    color: mTheme.onPrimaryContainer,
                  ),
                  centerTitle: true,
                ),
                body: LoadingEffect.getSearchLoadingScreen(
                  context,
                  theme,
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () => GoRouter.of(context).push('/'),
                    child: Icon(
                      FeatherIcons.chevronLeft,
                      size: 25,
                      color: mTheme.onBackground,
                    ),
                  ),
                  elevation: 0,
                  title: FxText.titleMedium(
                    S.current.profileTabProfile.toUpperCase(),
                    fontWeight: 700,
                    textScaleFactor: 1.2257,
                    color: mTheme.onPrimaryContainer,
                  ),
                  centerTitle: true,
                  actions: [
                    if (state.user.credId?.endsWith('@voccent.com') ?? false)
                      FxContainer(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(right: 16),
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const IWantToSpeakView(),
                          ),
                        ),
                        child: Icon(
                          FeatherIcons.star,
                          size: 25,
                          color: mTheme.onSurface,
                        ),
                      )
                    else
                      Container(),
                  ],
                ),
                body: Padding(
                  padding: FxSpacing.x(24),
                  child: ListView(
                    children: [
                      Center(
                        child: FxContainer(
                          color: mTheme.background,
                          paddingAll: 0,
                          bordered: true,
                          borderColor: mTheme.primary,
                          borderRadiusAll: 100,
                          height: 140,
                          width: 140,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: (state.user.asset?.userAvatar?.first ==
                                        null)
                                    ? Image.asset(
                                        'assets/images/avatar_place.png',
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        // ignore: lines_longer_than_80_chars
                                        '${context.read<ServerAddress>().httpUri}'
                                        '/api/v1/asset/file/user_avatar/'
                                        '${state.avatarData}',
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/avatar_place.png',
                                          height: 140,
                                          width: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FxSpacing.height(24),
                      Center(
                        child: Column(
                          children: [
                            FxText.bodyLarge(
                              '${state.user.firstname ?? ''} '
                                      '${state.user.lastname ?? ''}'
                                  .toUpperCase(),
                              fontWeight: 700,
                              color: mTheme.onPrimaryContainer,
                            ),
                            FxSpacing.height(5),
                            FxText.bodyMedium(
                              '${state.user.credId ?? ''} ',
                              fontWeight: 500,
                              color: mTheme.primary,
                            ),
                          ],
                        ),
                      ),
                      FxSpacing.height(24),
                      InkWell(
                        onTap: () =>
                            GoRouter.of(context).push('/profile/editor'),
                        child: _buildSingleSetting(
                          S.current.profileSettings,
                          '${S.current.accountDetails}, '
                          '${S.current.myLanguages}',
                          FeatherIcons.user,
                          mTheme.onPrimaryContainer,
                          mTheme.primary,
                        ),
                      ),
                      Divider(
                        color: mTheme.primary,
                        thickness: 0.2,
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PreferencesView(
                              languagesList: Dictionary.languages,
                            ),
                          ),
                        ),
                        child: _buildSingleSetting(
                          S.current.profileTabPreferences,
                          '${S.current.colorTheme}, '
                          '${S.current.appLanguage}',
                          FeatherIcons.settings,
                          mTheme.onPrimaryContainer,
                          mTheme.primary,
                        ),
                      ),
                      if (state.organizationID.isEmpty)
                        Divider(
                          color: mTheme.primary,
                          thickness: 0.2,
                        ),
                      if (state.organizationID.isEmpty)
                        InkWell(
                          onTap: () => GoRouter.of(context).push(
                            '/profile/subscriptions',
                          ),
                          child: _buildSingleSetting(
                            S.current.payments,
                            S.current.profileTabSubscriptions,
                            FeatherIcons.creditCard,
                            mTheme.onPrimaryContainer,
                            mTheme.primary,
                          ),
                        ),
                      Divider(
                        color: mTheme.primary,
                        thickness: 0.2,
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(context).push(
                          '/profile/about',
                        ),
                        child: _buildSingleSetting(
                          S.current.profileTabAbout,
                          S.current.profileTabAboutApp,
                          FeatherIcons.alertCircle,
                          mTheme.onPrimaryContainer,
                          mTheme.primary,
                        ),
                      ),
                      Divider(
                        color: mTheme.primary,
                        thickness: 0.2,
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(context).push(
                          '/profile/organizations',
                        ),
                        child: _buildSingleSetting(
                          S.current.organizations,
                          S.current.organizations,
                          FeatherIcons.octagon,
                          mTheme.onPrimaryContainer,
                          mTheme.primary,
                        ),
                      ),
                      Divider(
                        color: mTheme.primary,
                        thickness: 0.2,
                      ),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).go('/');
                          context.read<AuthCubit>().logout();
                        },
                        child: _buildSingleSetting(
                          S.current.profileTabLogout,
                          S.current.profileTabExit,
                          FeatherIcons.logOut,
                          mTheme.onPrimaryContainer,
                          mTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSingleSetting(
    String setting,
    String subSetting,
    IconData icon,
    Color? color,
    Color? iconColor,
  ) {
    return Padding(
      padding: FxSpacing.y(8),
      child: Row(
        children: [
          Icon(icon, size: 25, color: iconColor),
          FxSpacing.width(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleSmall(
                  setting,
                  fontWeight: 600,
                  color: color,
                ),
                FxSpacing.height(4),
                FxText.bodySmall(
                  subSetting,
                  fontWeight: 600,
                  xMuted: true,
                  fontSize: 10,
                  color: color,
                ),
              ],
            ),
          ),
          Icon(
            FeatherIcons.chevronRight,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
