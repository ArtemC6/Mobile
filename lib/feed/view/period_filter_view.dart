import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/widgets/date_picker.dart';
import 'package:voccent/generated/l10n.dart';

class PeriodFilterView extends StatelessWidget {
  const PeriodFilterView({super.key});

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
              S.current.filterChoosePeriod,
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
                            cubit.setPeriodFilter(FeedPeriodFilter.whenever);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodWhenever,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.whenever
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
                            cubit.setPeriodFilter(FeedPeriodFilter.today);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodToday,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.today
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
                            cubit.setPeriodFilter(FeedPeriodFilter.yesterday);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodYesterday,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.yesterday
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
                            cubit.setPeriodFilter(FeedPeriodFilter.last7days);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodLast7,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.last7days
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
                            cubit.setPeriodFilter(FeedPeriodFilter.last30days);
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodLast30,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.last30days
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
                          onTap: () async {
                            cubit.setPeriodFilter(
                              FeedPeriodFilter.customPeriod,
                            );
                            final pickedFrom = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime.now(),
                            );
                            if (pickedFrom != null) {
                              cubit.setCustomPeriodFrom(pickedFrom);
                            }
                            await Future<void>.delayed(
                              const Duration(
                                milliseconds: 500,
                              ),
                            );
                            final pickedTo = await showDatePicker(
                              // ignore: use_build_context_synchronously
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime.now(),
                            );
                            if (pickedTo != null) {
                              cubit.setCustomPeriodTo(pickedTo);
                            }
                          },
                          child: Padding(
                            padding: FxSpacing.xy(16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleSmall(
                                  S.current.filterPeriodCustom,
                                  fontWeight: 600,
                                ),
                                Icon(
                                  state.period == FeedPeriodFilter.customPeriod
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: mTheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 32,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  FxText.bodyMedium(
                                    S.current.filterDateFrom,
                                    fontWeight: 600,
                                    color: mTheme.onBackground,
                                  ),
                                  FxSpacing.height(8),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: mTheme.primary.withAlpha(200),
                                    ),
                                    child: Column(
                                      key: UniqueKey(),
                                      children: [
                                        DatePicker(
                                          isStartDate: true,
                                          callback: cubit.setCustomPeriodFrom,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  FxText.bodyMedium(
                                    S.current.filterDateTo,
                                    fontWeight: 600,
                                    color: mTheme.onBackground,
                                  ),
                                  FxSpacing.height(8),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: mTheme.primary.withAlpha(200),
                                    ),
                                    child: Column(
                                      key: UniqueKey(),
                                      children: [
                                        DatePicker(
                                          isStartDate: false,
                                          callback: cubit.setCustomPeriodTo,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (state.customPeriodTo != null &&
                            state.customPeriodFrom != null &&
                            state.customPeriodTo!
                                    .compareTo(state.customPeriodFrom!) ==
                                -1) ...[
                          FxSpacing.height(8),
                          FxText.bodyLarge(
                            'Selected date from is earlier than date to',
                            color: mTheme.error,
                          ),
                        ],
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
