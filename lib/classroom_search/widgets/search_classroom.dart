import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/themes/themes.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/classroom_search/widgets/classroom_search_card.dart';
import 'package:voccent/classroom_search/widgets/languages_filter.dart';
import 'package:voccent/debounce.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/widgets/loading_effect.dart';

class SearchClassroom extends StatefulWidget {
  const SearchClassroom({
    required this.filterQueryEdtCnt,
    required this.user,
    super.key,
  });

  final TextEditingController filterQueryEdtCnt;

  final User user;

  @override
  State<SearchClassroom> createState() => _SearchClassroomState();
}

class _SearchClassroomState extends State<SearchClassroom> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      context.read<ClassroomSearchCubit>().setQuery('');
      setState(() {});
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Debounce();
    final d15000 = Debounce(milliseconds: 1500);

    return BlocBuilder<ClassroomSearchCubit, ClassroomSearchState>(
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;
        final searchHistory =
            context.read<ClassroomSearchCubit>().getSearchHistory();
        return GestureDetector(
          onTap: focusNode.unfocus,
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FxContainer(
                    margin: FxSpacing.x(16),
                    padding: FxSpacing.y(6),
                    color: mTheme.primaryContainer,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadiusAll: 8,
                    child: TextField(
                      controller: widget.filterQueryEdtCnt,
                      focusNode: focusNode,
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
                          size: 20,
                          color: mTheme.onPrimaryContainer,
                        ),
                      ),
                      onChanged: (query) {
                        d.run(() {
                          context
                              .read<ClassroomSearchCubit>()
                              .setQuery(query.trim());
                        });
                        d15000.run(() {
                          context
                              .read<ClassroomSearchCubit>()
                              .saveSearchHistory(query.trim());
                        });
                      },
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
                                            .read<ClassroomSearchCubit>()
                                            .clearSearchHistory();
                                        Navigator.pop(context);
                                        focusNode.unfocus();
                                      },
                                    )
                                  : _deleteSearchHistoryDialog(
                                      context,
                                      () {
                                        context
                                            .read<ClassroomSearchCubit>()
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
                                color: Theme.of(context).colorScheme.primary,
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
                                        .read<ClassroomSearchCubit>()
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
                  padding: FxSpacing.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FxContainer(
                          borderRadiusAll: 8,
                          onTap: () {
                            context
                                .read<ClassroomSearchCubit>()
                                .loadLanguageFilter();
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ClassroomSearchCubit>(),
                                  child: const LanguagesFilter(),
                                ),
                              ),
                            );
                          },
                          paddingAll: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FeatherIcons.globe,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              FxSpacing.width(4),
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
                                        '${state.selectedLanguages.length}',
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
                      FxSpacing.width(4),
                      Expanded(
                        child: FxContainer(
                          borderRadiusAll: 8,
                          borderColor: mTheme.secondary,
                          onTap: () => context
                              .read<ClassroomSearchCubit>()
                              .clearFilters(),
                          padding: FxSpacing.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FeatherIcons.x,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                              FxSpacing.width(4),
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
                  child: BlocSelector<ClassroomSearchCubit,
                      ClassroomSearchState, int?>(
                    selector: (state) => state.searchClassroomItemsCount,
                    builder: (context, count) {
                      if (count == 0) {
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                S.current.genericNotFound,
                              ),
                              Text(
                                S.current.genericTryChangeSearch,
                              ),
                              OutlinedButton(
                                onPressed: () => context
                                    .read<ClassroomSearchCubit>()
                                    .clearFilters(),
                                child: Text(S.current.genericClearFilters),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        key: ObjectKey(state.searchClassromPages[0]),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = context
                              .read<ClassroomSearchCubit>()
                              .searchClassroomItem(index);

                          if (item.isLoading()) {
                            return LoadingEffect.getSearchLoadingScreen(
                              context,
                              Theme.of(context),
                            );
                          }
                          return ClassroomSearchCard(
                            card: item,
                            user: widget.user,
                          );
                        },
                        itemCount: count,
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
