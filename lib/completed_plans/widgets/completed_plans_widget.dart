import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/completed_plans/cubit/completed_plans_cubit.dart';
import 'package:voccent/completed_plans/cubit/models/completed_plans_model/finished_plan.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/radius_score_widget.dart';

class CompletedPlansWidget extends StatelessWidget {
  const CompletedPlansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocListener<CompletedPlansCubit, CompletedPlansState>(
      listener: (context, state) {
        if (state.pages.isEmpty) {
          context.read<CompletedPlansCubit>().fetchInitialData();
        }
      },
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
          title: FxText.titleMedium(
            S.current.achievementsCompletedPlans.toUpperCase(),
            fontWeight: 600,
            textScaleFactor: 1.2257,
            color: mTheme.primary,
          ),
        ),
        body: BlocBuilder<CompletedPlansCubit, CompletedPlansState>(
          builder: (context, state) {
            if (state.status == CompletedPlansStatus.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/search.json',
                      ),
                      FxText.titleLarge(
                        S.current.achievementsNoCompletedPlans,
                        textAlign: TextAlign.center,
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FxSpacing.height(8),
                Expanded(
                  child: ListView.builder(
                    key: ObjectKey(state.pages[0]),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item =
                          context.read<CompletedPlansCubit>().feedItem(index);
                      if (item.isLoading()) {
                        return LoadingEffect.getComplitedPlansLoading(
                          Theme.of(context),
                        );
                      }
                      return CompletedPlan(
                        plan: item,
                      );
                    },
                    itemCount: state.itemsCount,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CompletedPlan extends StatelessWidget {
  const CompletedPlan({
    required this.plan,
    super.key,
  });

  final FinishedPlan plan;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CompletedPlansCubit, CompletedPlansState>(
      builder: (context, state) {
        final pass = plan.pass!;
        final startAt = DateFormat().format(pass.startAt!);
        final endAt = DateFormat().format(pass.endAt!);
        final score = double.tryParse(pass.percent.toString()) ?? 0.0;

        return ClipRRect(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: FxContainer(
              onTap: () =>
                  GoRouter.of(context).push('/completedplans/${pass.id}'),
              color: isDarkTheme
                  ? FxAppTheme.theme.cardTheme.color
                  : mTheme.onPrimary.withOpacity(0.75),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.titleLarge(
                          pass.planName ?? '',
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                        FxSpacing.height(8),
                      ],
                    ),
                    Divider(
                      color: mTheme.onPrimary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: FxText.titleSmall(
                                '${S.current.genericStarted}:',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: FxText.titleMedium(
                                startAt,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: FxText.titleSmall(
                                '${S.current.genericCompleted}:',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: FxText.titleMedium(
                                endAt,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mTheme.onPrimary.withOpacity(0.15),
                                      blurRadius: 6,
                                      spreadRadius: 6,
                                    ),
                                  ],
                                ),
                                width: 75,
                                height: 75,
                                child: RadiusScoreWidget(
                                  percent: score / 100,
                                  fillColor: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      mTheme.primary,
                                      mTheme.secondary,
                                    ],
                                  ),
                                  lineColor: mTheme.primary,
                                  freeColor: mTheme.onPrimary,
                                  lineWidth: 2,
                                  child: FxText.titleLarge(
                                    '${score.toStringAsFixed(0)}%',
                                    color: mTheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
