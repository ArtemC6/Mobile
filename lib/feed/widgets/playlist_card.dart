import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/root/root_widget.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({required this.playlist, super.key});

  final FeedModel playlist;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/file/challenge_picture/${playlist.object?.pictureIdFirst}',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/content-types/playlists.jpeg',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );

    final langs = playlist.object?.languageIds != null
        ? Dictionary.languageNames(playlist.object!.languageIds!)
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FxContainer(
        marginAll: 8,
        onTap: () =>
            GoRouter.of(context).push('/playlist/${playlist.object?.id}'),
        child: Row(
          children: [
            if (playlist.object?.pictureIdFirst != null) ...[
              FxContainer(
                paddingAll: 0,
                clipBehavior: Clip.hardEdge,
                child: img,
              ),
              FxSpacing.width(16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FxText.bodyLarge(
                          playlist.object?.name ?? '',
                          fontWeight: 600,
                        ),
                      ),
                      if (playlist.object?.itemCount != null)
                        FxContainer(
                          color: mTheme.primary.withAlpha(36),
                          padding:
                              FxSpacing.symmetric(horizontal: 6, vertical: 4),
                          borderRadiusAll: 4,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FeatherIcons.play,
                                color: mTheme.primary,
                                size: 10,
                              ),
                              FxSpacing.width(4),
                              FxText.bodySmall(
                                playlist.object?.itemCount?.toString() ?? '',
                                fontSize: 10,
                                color: mTheme.primary,
                                fontWeight: 600,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  FxSpacing.height(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.language_outlined,
                        color: theme.colorScheme.onBackground.withAlpha(140),
                        size: 16,
                      ),
                      FxSpacing.width(8),
                      Expanded(
                        child: FxText.bodySmall(
                          langs,
                          xMuted: true,
                        ),
                      ),
                    ],
                  ),
                  FxSpacing.height(6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FxText.bodySmall(
                          '${playlist.object?.userName ?? ''} • '
                          '${playlist.object?.channelName ?? ''}',
                          xMuted: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
