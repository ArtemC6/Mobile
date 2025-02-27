import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/channel/cubit/channel_cubit.dart';
import 'package:voccent/chat/cubit/chat_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';

class ChannelWidget extends StatelessWidget {
  const ChannelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, ChannelState>(
      builder: _build,
    );
  }

  Widget _build(BuildContext context, ChannelState state) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final height = MediaQuery.of(context).size.height;
    final summary = state.channelSummary;
    final lastUpdated = summary?.lastUpdated != null
        ? DateFormat('dd/MM/yyyy').format(summary!.lastUpdated!)
        : '';

    return Scaffold(
      body: BlocBuilder<ChannelCubit, ChannelState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: height * 0.27 + 60,
                child: Stack(
                  children: [
                    if (state.channel?.asset?.channelBanner != null) ...[
                      ClipPath(
                        clipper: ClippingClass(),
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            '$apiBaseUrl/api/v1/asset/file/channel_banner/'
                            '${state.channel!.asset!.channelBanner![0]}',
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/Ccwhitebg.png',
                                fit: BoxFit.fitWidth,
                              );
                            },
                            height: height * 0.27,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ] else ...[
                      ClipPath(
                        clipper: ClippingClass(),
                        child: Container(
                          height: height * 0.26,
                          decoration: BoxDecoration(
                            color: mTheme.primary,
                          ),
                        ),
                      ),
                    ],
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                FeatherIcons.chevronLeft,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => _openChat(context, state),
                                  icon: const Icon(
                                    FeatherIcons.messageCircle,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Share.share(
                                      '$apiBaseUrl/try/c/${Uri.encodeComponent(state.channel?.name ?? '')}',
                                    );
                                  },
                                  icon: const Icon(
                                    FeatherIcons.share2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: mTheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(4, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: state.channel?.asset?.channelAvatar != null
                                ? Image.network(
                                    '$apiBaseUrl/api/v1/asset/file/channel_avatar/'
                                    // ignore: lines_longer_than_80_chars
                                    '${state.channel!.asset!.channelAvatar![0]}',
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    'assets/images/Ccwhitebg.png',
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: FxText.titleLarge(
                            textAlign: TextAlign.center,
                            state.channel?.name ?? '',
                            fontWeight: 900,
                            textScaleFactor: 1.14,
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: FxText.bodyLarge(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 7,
                            textAlign: TextAlign.center,
                            state.channel?.name == state.channel?.description
                                ? ''
                                : state.channel?.description ?? '',
                            color: mTheme.onSurface.withOpacity(1),
                            fontWeight: 900,
                            fontSize: 16,
                            textScaleFactor: 1,
                          ),
                        ),
                        if (state.channelSummary != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: mTheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(4, 8),
                                  ),
                                ],
                              ),
                              child: FxContainer(
                                child: Column(
                                  children: [
                                    FxSpacing.height(2),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              FxText.bodyLarge(
                                                S.current.searchTabPlaylists,
                                                color: mTheme.onSurface
                                                    .withOpacity(1),
                                                textAlign: TextAlign.start,
                                                fontWeight: 600,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              FxText.bodySmall(
                                                '(${S.current.genericAll}/${S.current.lastMonth})',
                                                color: mTheme.onSurface
                                                    .withOpacity(1),
                                                textAlign: TextAlign.start,
                                                fontSize: 10,
                                              ),
                                            ],
                                          ),
                                          FxText.bodySmall(
                                            '${summary?.playlists} / ${summary?.playlistsThisMonth}',
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FxText.bodyLarge(
                                            S.current.searchTabChallenges,
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontWeight: 600,
                                          ),
                                          FxText.bodySmall(
                                            '${summary?.challenges} / ${summary?.challengesThisMonth}',
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FxText.bodyLarge(
                                            S.current.searchTabStories,
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontWeight: 600,
                                          ),
                                          FxText.bodySmall(
                                            '${summary?.stories} / ${summary?.storiesThisMonth}',
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              FxText.bodyLarge(
                                                '${S.current.rating} ',
                                                color: mTheme.onSurface
                                                    .withOpacity(1),
                                                textAlign: TextAlign.start,
                                                fontWeight: 600,
                                              ),
                                              FxText.bodySmall(
                                                '(%/${S.current.amount})',
                                                color: mTheme.onSurface
                                                    .withOpacity(1),
                                                textAlign: TextAlign.start,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, size: 18),
                                              FxText.bodySmall(
                                                '${(summary?.rating ?? 0).toStringAsFixed(0)} / ${summary?.countRating}',
                                                color: mTheme.onSurface
                                                    .withOpacity(1),
                                                textAlign: TextAlign.start,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FxText.bodyLarge(
                                            S.current.lastUpdated,
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontWeight: 600,
                                          ),
                                          FxText.bodySmall(
                                            lastUpdated,
                                            color:
                                                mTheme.onSurface.withOpacity(1),
                                            textAlign: TextAlign.start,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    FxSpacing.height(2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    FxSpacing.height(30),
                  ],
                ),
              ),
              if (state.channel != null)
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: FxButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      borderRadiusAll: 8,
                      onPressed: () => GoRouter.of(context).push(
                        '/channel/${state.channel!.id}/content',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FxText(
                            S.current.goToChannel,
                            fontWeight: 900,
                            color: mTheme.onPrimary,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              FxSpacing.height(18),
            ],
          );
        },
      ),
    );
  }
}

void _openChat(BuildContext context, ChannelState state) {
  if (state.channel?.id != null) {
    context
        .read<ChatCubit>()
        .writeToAuthor(
          state.channel!.id!,
        )
        .then(
          (value) => GoRouter.of(context).go(
            '/chatroom/$value',
          ),
        );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 20)
      ..quadraticBezierTo(
        size.width / 4,
        size.height,
        size.width / 2,
        size.height,
      )
      ..quadraticBezierTo(
        size.width - (size.width / 4),
        size.height,
        size.width,
        size.height - 20,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TableInfoWidget extends StatelessWidget {
  const TableInfoWidget({
    required this.labels,
    required this.values,
    super.key,
  });
  final List<Widget> labels;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return FxContainer(
      color: Colors.transparent,
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
            children: [
              for (int i = 0; i < labels.length; i++)
                if (values[i] != '')
                  TableRow(
                    children: [
                      labels[i],
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: FxText.bodyMedium(
                          values[i],
                          color: mTheme.onBackground,
                          textAlign: TextAlign.end,
                          fontWeight: 600,
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
