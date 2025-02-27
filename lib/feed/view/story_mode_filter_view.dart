import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/generated/l10n.dart';

class StoryModeFilterView extends StatelessWidget {
  const StoryModeFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        final cubit = context.read<FeedCubit>();

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
            title: FxText.bodyLarge(
              S.current.filterChooseStoryMode,
              fontWeight: 700,
            ),
          ),
          body: Column(
            children: [
              BlocBuilder<FeedCubit, FeedState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView(
                      children: [
                        FxSpacing.height(4),
                        InkWell(
                          onTap: () {
                            cubit.setStoryTypeFilter(-1);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterStoryModeAny,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.storyModeType == -1
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: mTheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        InkWell(
                          onTap: () {
                            cubit.setStoryTypeFilter(0);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterStoryModeRoles,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.storyModeType == 0
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: mTheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        InkWell(
                          onTap: () {
                            cubit.setStoryTypeFilter(2);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterStoryModeCertification,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.storyModeType == 2
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: mTheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                padding: FxSpacing.x(60),
                width: double.infinity,
                child: FloatingActionButton.extended(
                  elevation: 0,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    FeatherIcons.check,
                    color: mTheme.onPrimary,
                  ),
                  label: FxText.bodyLarge(
                    S.current.filterApply,
                    fontWeight: 700,
                    color: mTheme.onPrimary,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  backgroundColor: mTheme.primary,
                ),
              ),
              FxSpacing.height(60),
            ],
          ),
        );
      },
    );
  }
}
