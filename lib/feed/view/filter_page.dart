import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/view/authors_filter_view.dart';
import 'package:voccent/feed/view/level_filter_view.dart';
import 'package:voccent/feed/view/period_filter_view.dart';
import 'package:voccent/feed/view/story_mode_filter_view.dart';
import 'package:voccent/generated/l10n.dart';

class FiltersPage extends StatelessWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        elevation: 0,
        title: FxText.titleMedium(
          S.current.filterFilters,
          fontWeight: 700,
          textScaleFactor: 1.2257,
          color: mTheme.onPrimaryContainer,
        ),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<FeedCubit>(),
                            child: const AuthorsFilterView(),
                          ),
                        ),
                      ),
                      child: _buildSingleFilter(
                        S.current.filterAuthor,
                        state.author != ''
                            ? state.author
                            : S.current.filterAllAuthors,
                        FeatherIcons.users,
                        mTheme,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<FeedCubit>(),
                            child: const PeriodFilterView(),
                          ),
                        ),
                      ),
                      child: _buildSingleFilter(
                        S.current.filterPeriod,
                        state.periodString,
                        FeatherIcons.users,
                        mTheme,
                      ),
                    ),
                  ),
                  if (state.tab == FeedTab.story)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => BlocProvider.value(
                              value: context.read<FeedCubit>(),
                              child: const StoryModeFilterView(),
                            ),
                          ),
                        ),
                        child: _buildSingleFilter(
                          S.current.filterStoryMode,
                          state.storyModeString,
                          FeatherIcons.users,
                          mTheme,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<FeedCubit>(),
                            child: const LevelFilterView(),
                          ),
                        ),
                      ),
                      child: _buildSingleFilter(
                        S.current.filterLevel,
                        '${state.levelFrom} - ${state.levelTo}',
                        FeatherIcons.trendingUp,
                        mTheme,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        InkWell(
                          child: FxText.titleSmall(
                            S.current.filterMySourceLanguages,
                            fontWeight: 600,
                            color: mTheme.onSurface,
                          ),
                          onTap: () {
                            context.read<FeedCubit>().setSourceLanguages();
                          },
                        ),
                        Checkbox(
                          value: state.sourceLanguages_,
                          onChanged: (value) =>
                              context.read<FeedCubit>().setSourceLanguages(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: mTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: FxSpacing.x(60),
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      elevation: 0,
                      onPressed: () {
                        context.read<FeedCubit>().applyFilterForm();
                        context.read<FeedCubit>().startNewFeed();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        FeatherIcons.check,
                        color: mTheme.onPrimary,
                      ),
                      label: FxText.bodyLarge(
                        S.current.filterApplyFilters,
                        fontWeight: 700,
                        color: mTheme.onPrimary,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      backgroundColor: mTheme.primary,
                    ),
                  ),
                  FxSpacing.height(60),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSingleFilter(
    String filterName,
    String currentFilterValue,
    IconData icon,
    ColorScheme mTheme,
  ) {
    return Padding(
      padding: FxSpacing.y(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: mTheme.primary),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleSmall(
                      filterName,
                      fontWeight: 600,
                      color: mTheme.onSurface,
                    ),
                    FxSpacing.height(4),
                    FxText.bodySmall(
                      currentFilterValue,
                      fontWeight: 600,
                      xMuted: true,
                      fontSize: 10,
                      color: mTheme.onSurface,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              FeatherIcons.chevronRight,
              color: mTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
