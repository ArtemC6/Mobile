import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/widgets/level_slider.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';

class LevelFilterView extends StatelessWidget {
  const LevelFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;
        final theme = context.watch<ThemeCubit>().state.theme;

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
              S.current.filterChooseLevel,
              fontWeight: 700,
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    FxSpacing.height(4),
                    const LevelSlider(),
                    // Note: we use CEFR table from https://www.efset.org/english-score/
                    Container(
                      color: theme.colorScheme.background,
                      padding: const EdgeInsets.all(20),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: FxText(
                              'CEFR',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: FxText(
                              S.current.filterLevel,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(FxText('1 - 10')),
                              DataCell(FxText('< A1')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('11 - 30')),
                              DataCell(FxText('A1 ${S.current.beginner}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('31 - 40')),
                              DataCell(FxText('A2 ${S.current.elementary}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('41 - 50')),
                              DataCell(FxText('B1 ${S.current.intermediate}')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('51 - 60')),
                              DataCell(
                                FxText('B2 ${S.current.upperIntermediate}'),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('61 - 70')),
                              DataCell(
                                FxText('C1 ${S.current.advanced}'),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(FxText('71 - 100')),
                              DataCell(FxText('C2 ${S.current.proficient}')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FxText.bodyMedium(
                        S.current.theCommonEuropeanFrameworkOfReference,
                      ),
                    ),
                  ],
                ),
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
