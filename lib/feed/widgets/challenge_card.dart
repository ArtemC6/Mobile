import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/root/root_widget.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({required this.challenge, this.channelId, super.key});

  final FeedModel challenge;
  final String? channelId;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    final pic = challenge.object?.asset?.challengePicture?[0];

    final lang = challenge.object?.languageId != null
        ? Dictionary.languageNames([challenge.object!.languageId!])
        : '';

    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/file/challenge_picture/$pic',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/content-types/challenges.jpeg',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FxContainer(
        key: key,
        marginAll: 8,
        onTap: () => GoRouter.of(context).push(
          '/challenge/${challenge.id}',
        ),
        child: Row(
          children: [
            if (pic != null) ...[
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
                          challenge.object?.name ?? '',
                          fontWeight: 600,
                        ),
                      ),
                      if ((challenge.object?.rating ?? 0) > 0)
                        FxContainer(
                          color: mTheme.secondary.withAlpha(36),
                          padding:
                              FxSpacing.symmetric(horizontal: 6, vertical: 4),
                          borderRadiusAll: 4,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FeatherIcons.star,
                                color: mTheme.secondary,
                                size: 10,
                              ),
                              FxSpacing.width(4),
                              FxText.bodySmall(
                                double.parse(
                                  challenge.object?.rating?.toString() ?? '0',
                                ).toStringAsFixed(1),
                                fontSize: 10,
                                color: mTheme.secondary,
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
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(140),
                        size: 16,
                      ),
                      FxSpacing.width(8),
                      Expanded(
                        child: FxText.bodySmall(
                          lang,
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
                          '${challenge.object?.userName ?? ''} • '
                          '${challenge.object?.channelName ?? ''}',
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
