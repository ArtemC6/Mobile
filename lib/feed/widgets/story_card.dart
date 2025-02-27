import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/root/root_widget.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({required this.story, super.key});

  final FeedModel story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}/api/v1/asset/object/'
      'story_picture/${story.id}',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/voc_button.png',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );

    final langs = story.object?.languageIds != null
        ? Dictionary.languageNames(story.object!.languageIds!)
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FxContainer(
        marginAll: 8,
        onTap: () => GoRouter.of(context).push(
          '/story/${story.object?.id}?l=${story.object?.currentPass?.link ?? ''}',
        ),
        child: Row(
          children: [
            FxContainer(
              paddingAll: 0,
              clipBehavior: Clip.hardEdge,
              child: img,
            ),
            FxSpacing.width(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FxText.bodyLarge(
                          story.object?.name ?? '',
                          fontWeight: 600,
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
                          '${story.object?.userName} • '
                          '${story.object?.channelName}',
                          xMuted: true,
                        ),
                      ),
                    ],
                  ),
                  if (story.object?.levels != null) ...[
                    FxSpacing.height(6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FxText.bodySmall(
                            'Logical levels: ${story.object?.levels}',
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
                            'Total elements: ${story.object?.actItems ?? 0}',
                            xMuted: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
