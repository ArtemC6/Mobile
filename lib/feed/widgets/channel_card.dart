import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/root/root_widget.dart';

class ChannelCard extends StatelessWidget {
  const ChannelCard({required this.channel, super.key});

  final FeedModel channel;

  @override
  Widget build(BuildContext context) {
    final pic = channel.object?.asset?.channelAvatar?[0];

    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/file/channel_avatar/$pic',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/content-types/channels.jpeg',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );

    final langs = channel.object?.languageIds != null
        ? Dictionary.languageNames(channel.object!.languageIds!)
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FxContainer(
        marginAll: 8,
        onTap: () =>
            GoRouter.of(context).push('/channel/${channel.object?.id}'),
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
                          channel.object?.name ?? '',
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
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(140),
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
                          channel.object?.userName ?? '',
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
