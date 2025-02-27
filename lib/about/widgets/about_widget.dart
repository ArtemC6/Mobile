import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/about/cubit/about_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          S.current.profileTabAbout.toUpperCase(),
          fontWeight: 600,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: BlocBuilder<AboutCubit, AboutState>(
        builder: (context, state) {
          return ListView(
            children: [
              const Divider(),
              _buildSingleInfoPanel(
                'App name: ',
                state.appName ?? 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Package name: ',
                state.packageName ?? 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Version: ',
                state.version ?? 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Build number: ',
                state.buildNumber ?? 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'User: ',
                context.read<HomeCubit>().state.user.credId ?? '',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Push notifications: ',
                state.pushyCreds ?? 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Stories: ',
                state.storiesStatus != null
                    ? state.storiesStatus!
                        ? 'Operational'
                        : 'Down'
                    : 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Chat: ',
                state.chatStatus != null
                    ? state.chatStatus!
                        ? 'Operational'
                        : 'Down'
                    : 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Challenges: ',
                state.challengesStatus != null
                    ? state.challengesStatus!
                        ? 'Operational'
                        : 'Down'
                    : 'Loading...',
                mTheme,
              ),
              const Divider(),
              _buildSingleInfoPanel(
                'Playlists: ',
                state.playlistsStatus != null
                    ? state.playlistsStatus!
                        ? 'Operational'
                        : 'Down'
                    : 'Loading...',
                mTheme,
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSingleInfoPanel(
    String setting,
    String value,
    ColorScheme mTheme,
  ) {
    return Padding(
      padding: FxSpacing.xy(24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleSmall(
            setting,
            fontWeight: 600,
            color: mTheme.onPrimaryContainer,
          ),
          Expanded(
            child: FxText.titleSmall(
              value,
              textAlign: TextAlign.end,
              fontWeight: 500,
              color: mTheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
