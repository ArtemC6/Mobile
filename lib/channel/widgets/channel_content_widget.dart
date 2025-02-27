import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/channel/cubit/channel_cubit.dart';
import 'package:voccent/channel/widgets/channel_tab_button_widget.dart';
import 'package:voccent/debounce.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/widgets/challenge_card.dart';
import 'package:voccent/feed/widgets/playlist_card.dart';
import 'package:voccent/feed/widgets/story_card.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/loading_effect.dart';

class ChannelContentWidget extends StatelessWidget {
  const ChannelContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, ChannelState>(
      builder: _build,
    );
  }

  Widget _build(BuildContext context, ChannelState state) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;
    final d = Debounce();

    return Scaffold(
      appBar: AppBar(
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
          state.channel?.name?.toUpperCase() ?? '',
          fontWeight: 700,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FxContainer(
              padding: FxSpacing.y(6),
              color: mTheme.primaryContainer,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadiusAll: 8,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    FxSpacing.width(16),
                    Expanded(
                      child: TextField(
                        cursorColor: mTheme.onPrimaryContainer,
                        style: FxTextStyle.bodyMedium(),
                        decoration: InputDecoration(
                          hintText: S.current.genericTypeHere,
                          hintStyle: FxTextStyle.bodySmall(
                            color: mTheme.onPrimaryContainer,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (query) {
                          d.run(() {
                            context.read<ChannelCubit>().setQuery(query);
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FeatherIcons.search,
                        size: 20,
                        color: mTheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocSelector<ChannelCubit, ChannelState, int?>(
              selector: (state) => state.itemsCount,
              builder: (context, feedItemCount) {
                if (feedItemCount == 0) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          S.current.genericNotFound,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  key: ObjectKey(state.pages[0]),
                  itemBuilder: (context, index) {
                    final feedItem =
                        context.read<ChannelCubit>().feedItem(index);

                    if (feedItem.isLoading()) {
                      return LoadingEffect.getConfirmPaymentLoadingScreen(
                        context,
                        theme,
                      );
                    }

                    switch (feedItem.type) {
                      case 'playlist':
                        return PlaylistCard(playlist: feedItem);
                      case 'challenge':
                        return ChallengeCard(
                          challenge: feedItem,
                          channelId: '${state.channel?.id}',
                        );
                      case 'story':
                        return StoryCard(
                          story: feedItem,
                        );
                      default:
                        return FxText.bodyMedium('27a7f0a5: Unknown item type');
                    }
                  },
                  itemCount: feedItemCount,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChannelTabButtonWidget(
                  tab: FeedTab.feed,
                  isActive: state.tab == FeedTab.feed,
                  text: S.current.searchTabFeed,
                  color: const Color.fromARGB(255, 136, 255, 136),
                  borderColor: const Color.fromARGB(255, 106, 225, 106),
                ),
                ChannelTabButtonWidget(
                  tab: FeedTab.playlist,
                  isActive: state.tab == FeedTab.playlist,
                  text: S.current.searchTabPlaylists,
                  color: const Color.fromARGB(255, 255, 247, 136),
                  borderColor: const Color.fromARGB(255, 234, 226, 107),
                ),
                ChannelTabButtonWidget(
                  tab: FeedTab.challenge,
                  isActive: state.tab == FeedTab.challenge,
                  text: S.current.searchTabChallenges,
                  color: const Color.fromARGB(255, 136, 144, 255),
                  borderColor: const Color.fromARGB(255, 93, 100, 203),
                ),
                ChannelTabButtonWidget(
                  tab: FeedTab.story,
                  isActive: state.tab == FeedTab.story,
                  text: S.current.searchTabStories,
                  color: const Color.fromARGB(255, 255, 136, 136),
                  borderColor: const Color.fromARGB(255, 203, 94, 94),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
