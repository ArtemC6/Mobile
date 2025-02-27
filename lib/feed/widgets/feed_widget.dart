import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/themes/themes.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/debounce.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/view/filter_page.dart';
import 'package:voccent/feed/view/languages_filter_view.dart';
import 'package:voccent/feed/widgets/category_select_widget.dart';
import 'package:voccent/feed/widgets/challenge_card.dart';
import 'package:voccent/feed/widgets/channel_card.dart';
import 'package:voccent/feed/widgets/playlist_card.dart';
import 'package:voccent/feed/widgets/story_card.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/widgets/loading_effect.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _key = GlobalKey();
  final _controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      context.read<FeedCubit>().setQuery('');
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.removeListener(_handleFocusChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Debounce();
    final d15000 = Debounce(milliseconds: 1500);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.user.id == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        } else {
          return BlocConsumer<FeedCubit, FeedState>(
            listenWhen: (previous, current) =>
                current.pages[0]?.isLoading == false &&
                current.tab == FeedTab.challenge,
            listener: (context, state) {},
            builder: (context, state) {
              final mTheme = Theme.of(context).colorScheme;
              final languages = state.selectedLanguages;
              final searchHistory =
                  context.read<FeedCubit>().getSearchHistory();

              return GestureDetector(
                onTap: focusNode.unfocus,
                child: Scaffold(
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
                    title: () {
                      switch (state.tab) {
                        case FeedTab.feed:
                          return FxText.titleMedium(
                            S.current.searchTabFeed.toUpperCase(),
                            fontWeight: 700,
                            textScaleFactor: 1.2257,
                            color: mTheme.primary,
                          );
                        case FeedTab.challenge:
                          return FxText.titleMedium(
                            S.current.discoveryChallenges.toUpperCase(),
                            fontWeight: 700,
                            textScaleFactor: 1.2257,
                            color: mTheme.primary,
                          );
                        case FeedTab.playlist:
                          return FxText.titleMedium(
                            S.current.discoveryPlaylists.toUpperCase(),
                            fontWeight: 700,
                            textScaleFactor: 1.2257,
                            color: mTheme.primary,
                          );
                        case FeedTab.channel:
                          return FxText.titleMedium(
                            S.current.discoveryChannels.toUpperCase(),
                            fontWeight: 700,
                            textScaleFactor: 1.2257,
                            color: mTheme.primary,
                          );
                        case FeedTab.story:
                          return FxText.titleMedium(
                            S.current.discoveryStories.toUpperCase(),
                            fontWeight: 700,
                            textScaleFactor: 1.2257,
                            color: mTheme.primary,
                          );
                      }
                    }(),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FxContainer(
                          margin: FxSpacing.x(10),
                          padding: FxSpacing.y(2),
                          color: mTheme.primaryContainer,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadiusAll: 14,
                          child: Row(
                            children: [
                              FxSpacing.width(8),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: focusNode,
                                  autofocus: state.tab == FeedTab.feed,
                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor: mTheme.onPrimaryContainer,
                                  style: FxTextStyle.bodyMedium(
                                    color: mTheme.onPrimaryContainer,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: S.current.genericTypeHere,
                                    hintStyle: FxTextStyle.bodyMedium(
                                      color: mTheme.onPrimaryContainer,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    prefixIcon: Icon(
                                      FeatherIcons.search,
                                      size: 28,
                                      color: mTheme.onPrimaryContainer,
                                    ),
                                  ),
                                  onChanged: (query) {
                                    d.run(() {
                                      context
                                          .read<FeedCubit>()
                                          .setQuery(query.trim());
                                    });

                                    d15000.run(() {
                                      context
                                          .read<FeedCubit>()
                                          .saveSearchHistory(query.trim());
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: context.read<FeedCubit>()
                                            ..fillFilterForm(),
                                        ),
                                      ],
                                      child: const FiltersPage(),
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  FeatherIcons.sliders,
                                  size: 20,
                                  color: mTheme.onPrimaryContainer,
                                ),
                              ),
                              FxSpacing.width(8),
                            ],
                          ),
                        ),
                      ),
                      if (focusNode.hasFocus &&
                          state.query.isEmpty &&
                          searchHistory.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FxContainer(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(
                              top: 12,
                              right: 8,
                              left: 8,
                            ),
                            height: 50,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => showDialog<void>(
                                    context: context,
                                    builder: (notThisContext) => Platform.isIOS
                                        ? _deleteSearchHistoryIosDialog(
                                            context,
                                            () {
                                              context
                                                  .read<FeedCubit>()
                                                  .clearSearchHistory();
                                              Navigator.pop(context);
                                              focusNode.unfocus();
                                            },
                                          )
                                        : _deleteSearchHistoryDialog(
                                            context,
                                            () {
                                              context
                                                  .read<FeedCubit>()
                                                  .clearSearchHistory();
                                              Navigator.pop(context);
                                              focusNode.unfocus();
                                            },
                                          ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Icon(
                                      FeatherIcons.trash2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: searchHistory.length,
                                    itemBuilder: (context, index) {
                                      return FxContainer(
                                        onTap: () {
                                          context
                                              .read<FeedCubit>()
                                              .setQuery(searchHistory[index]);
                                          focusNode.unfocus();
                                        },
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        padding: FxSpacing.symmetric(
                                          horizontal: 16,
                                        ),
                                        borderRadiusAll: 4,
                                        child: Center(
                                          child: FxText.bodyLarge(
                                            searchHistory[index],
                                            fontWeight: 600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 2,
                          left: 14,
                          right: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FxContainer(
                                margin: FxSpacing.x(4),
                                paddingAll: 12,
                                borderRadiusAll: 8,
                                onTap: () => Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<FeedCubit>()
                                        ..loadFilters(),
                                      child: const LanguagesFilterView(),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FeatherIcons.globe,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 18,
                                    ),
                                    FxSpacing.width(6),
                                    FxText.bodySmall(
                                      S.current.filterLanguage,
                                      fontWeight: 600,
                                      letterSpacing: 0,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ),
                                    if (state.selectedLanguages.isNotEmpty)
                                      SizedBox(
                                        height: 18,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: mTheme.secondary,
                                            child: FxText.bodySmall(
                                              '${languages.length}',
                                              fontSize: 8,
                                              fontWeight: 800,
                                              letterSpacing: 0,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: FxContainer(
                                  paddingAll: 12,
                                  onTap: () => Navigator.of(context).push<void>(
                                    MaterialPageRoute<void>(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: context.read<FeedCubit>()
                                              ..loadFilters(),
                                          ),
                                        ],
                                        child: const CategorySelectWidget(),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FeatherIcons.grid,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 16,
                                      ),
                                      FxSpacing.width(6),
                                      FxText.bodySmall(
                                        S.current.filterCategory,
                                        fontWeight: 600,
                                        letterSpacing: 0,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: FxContainer(
                                margin: FxSpacing.x(4),
                                paddingAll: 12,
                                onTap: () {
                                  context.read<FeedCubit>().clearFilters();
                                  _controller.clear();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FeatherIcons.x,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 18,
                                    ),
                                    FxSpacing.width(6),
                                    FxText.bodySmall(
                                      S.current.filterReset,
                                      fontWeight: 600,
                                      letterSpacing: 0,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocSelector<FeedCubit, FeedState, int?>(
                          selector: (state) => state.itemsCount,
                          builder: (context, count) {
                            if (count == 0) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                      'assets/lottie/search.json',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                      child: FxText.displayMedium(
                                        S.current.genericTryChangeSearch,
                                        textAlign: TextAlign.center,
                                        color: mTheme.onSurface.withOpacity(1),
                                        fontWeight: 700,
                                        fontSize: 27,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: FxContainer(
                                        onTap: () {
                                          context
                                              .read<FeedCubit>()
                                              .clearFilters();
                                          _controller.clear();
                                        },
                                        color: mTheme.primary,
                                        borderColor: Colors.white,
                                        padding: const EdgeInsets.all(14),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          S.current.genericClearFilters,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                focusNode.unfocus();
                                return true;
                              },
                              child: ListView.builder(
                                key: ObjectKey(state.pages[0]),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item =
                                      context.read<FeedCubit>().feedItem(index);

                                  if (item.isLoading()) {
                                    return LoadingEffect.getSearchLoadingScreen(
                                      context,
                                      Theme.of(context),
                                    );
                                  }

                                  switch (item.type) {
                                    case 'channel':
                                      return ChannelCard(channel: item);
                                    case 'playlist':
                                      return PlaylistCard(playlist: item);
                                    case 'challenge':
                                      if (index == 0) {
                                        return Container(
                                          key: _key,
                                          child: ChallengeCard(challenge: item),
                                        );
                                      }

                                      return ChallengeCard(challenge: item);
                                    case 'story':
                                    default:
                                      return StoryCard(
                                        story: item,
                                      );
                                  }
                                },
                                itemCount: count,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

Widget _deleteSearchHistoryIosDialog(
  BuildContext context,
  void Function() onPressed,
) {
  return CupertinoAlertDialog(
    title: const Text('Search history deletion'),
    content: Text(S.current.feedOperationDelete),
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
        onPressed: onPressed,
        child: Text(S.current.genericDelete),
      ),
    ],
  );
}

Widget _deleteSearchHistoryDialog(
  BuildContext context,
  void Function() onPressed,
) {
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
                  child: FxText.titleLarge(
                    'Search history deletion',
                    fontWeight: 600,
                  ),
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
                children: <TextSpan>[
                  TextSpan(
                    text: S.current.feedOperationDelete,
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
                  onPressed: () => Navigator.pop(context),
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
                  onPressed: onPressed,
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
