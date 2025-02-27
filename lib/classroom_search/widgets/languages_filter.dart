import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/generated/l10n.dart';

class LanguagesFilter extends StatelessWidget {
  const LanguagesFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<ClassroomSearchCubit, ClassroomSearchState>(
      builder: (context, state) {
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
              S.current.filterSelectLanguages,
              fontWeight: 700,
            ),
            actions: [
              InkWell(
                onTap: () =>
                    context.read<ClassroomSearchCubit>().setAllLanguages(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    state.userLanguages.length ==
                            state.selectedLanguages_.length
                        ? FeatherIcons.checkSquare
                        : FeatherIcons.square,
                    color: mTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.userLanguages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => context
                          .read<ClassroomSearchCubit>()
                          .setLanguageFilter(
                            state.userLanguages[index],
                          ),
                      child: Container(
                        padding: FxSpacing.x(20),
                        key: UniqueKey(),
                        child: Column(
                          children: [
                            FxSpacing.height(4),
                            Padding(
                              padding: FxSpacing.y(4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxText.titleSmall(
                                    state.userLanguages[index].name,
                                    fontWeight: 600,
                                  ),
                                  Icon(
                                    state.selectedLanguages_.any(
                                      (e) =>
                                          e.id == state.userLanguages[index].id,
                                    )
                                        ? FeatherIcons.checkSquare
                                        : FeatherIcons.square,
                                    color: mTheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: FxSpacing.only(
                  left: 60,
                  right: 60,
                  bottom: 60,
                ),
                width: double.infinity,
                child: FloatingActionButton.extended(
                  elevation: 0,
                  onPressed: () {
                    context.read<ClassroomSearchCubit>().startNewSearch();
                    Navigator.of(context).pop();
                  },
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
            ],
          ),
        );
      },
    );
  }
}
