import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
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
      body: BlocBuilder<ClassroomSearchCubit, ClassroomSearchState>(
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
                    child: Row(
                      children: [
                        InkWell(
                          child: FxText.titleSmall(
                            S.current.filterMySourceLanguages,
                            fontWeight: 600,
                            color: mTheme.onSurface,
                          ),
                          onTap: () {
                            context
                                .read<ClassroomSearchCubit>()
                                .setSourceLanguages();
                          },
                        ),
                        Checkbox(
                          value: state.sourceLanguages_,
                          onChanged: (value) => context
                              .read<ClassroomSearchCubit>()
                              .setSourceLanguages(),
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
                        context.read<ClassroomSearchCubit>().applyFilterForm();
                        context.read<ClassroomSearchCubit>().startNewSearch();
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
}
