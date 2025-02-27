import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_cubit.dart';
import 'package:voccent/challenge/cubit/challenge_share_attempt_state.dart';
import 'package:voccent/challenge/widgets/attempts/all_attempts_widget.dart';
import 'package:voccent/challenge/widgets/attempts/my_attempts_widget.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/web_socket/web_socket.dart';

class AttemptsView extends StatelessWidget {
  const AttemptsView({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ChallengeCubit>.value(
                value: context.read<ChallengeCubit>()..loadMyAttempts(),
              ),
              BlocProvider<HomeCubit>.value(
                value: context.read<HomeCubit>(),
              ),
              BlocProvider(
                create: (context) => ShareAttemptCubit(
                  context.read<UserScopeClient>(),
                  context.read<AuthCubit>().state.userToken,
                  context.read<WebSocket>(),
                  context.read<ChallengeCubit>().state.challenge!.id,
                  context.read<HomeCubit>().state.user.id,
                )..init(),
              ),
            ],
            child: const TabBarWidget(),
          ),
        ),
      ),
      child: Icon(
        Icons.list,
        color: mTheme.onSurface.withOpacity(1),
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<ShareAttemptCubit, ShareAttemptState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  FeatherIcons.chevronLeft,
                  size: 25,
                  color: mTheme.onBackground,
                ),
              ),
              centerTitle: true,
              title: FxText.titleMedium(
                S.current.genericAttempts.toUpperCase(),
                fontWeight: 900,
                textScaleFactor: 1.2257,
                color: mTheme.primary,
              ),
              bottom: TabBar(
                tabs: [
                  Tab(text: S.current.genericMy),
                  Tab(text: S.current.genericAll),
                ],
                automaticIndicatorColorAdjustment: false,
                labelColor: mTheme.primary,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: mTheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            body: state.isProgress
                ? const Center(child: CircularProgressIndicator())
                : const TabBarView(
                    children: [
                      MyAttemptsWidget(),
                      AllAttemptsWidget(),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
