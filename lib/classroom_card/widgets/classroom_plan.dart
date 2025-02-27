import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/plan_pass/plan_pass_data.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/dialog.dart';

class ClassroomPlan extends StatelessWidget {
  const ClassroomPlan({required this.index, required this.isLocked, super.key});

  final int index;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: (context, state) {
        final apiBaseUrl = context.read<ServerAddress>().httpUri;
        final cache = context.read<ServerAddress>().cacheImgHash();

        final plan = state.classroom?.currentPlans?[index];
        final planId = plan?.planId;
        final classroomId = plan?.classroomId;

        final planStarted =
            (plan?.userPassing ?? false) && plan?.userPassingScore != null;

        return GestureDetector(
          onTap: isLocked
              ? () {
                  showInfoPlan(
                    context,
                    S.current.toOpenCurrentPlanPreviousOne,
                  );
                }
              : () {
                  context.read<ClassroomCardCubit>().setPlanUserPassing(index);
                  GoRouter.of(context).push(
                    '/plan_pass/$planId/$classroomId/true',
                    extra: PlanPassData(
                      classroomCardCubit: context.read<ClassroomCardCubit>(),
                      index: index,
                    ),
                  );
                },
          child: FxContainer(
            color: isDarkTheme
                ? isLocked
                    ? Colors.black.withOpacity(0.4)
                    : FxAppTheme.theme.cardTheme.color
                : isLocked
                    ? Colors.black.withOpacity(0.2)
                    : mTheme.onPrimary.withOpacity(0.75),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.titleMedium(
                          '${index + 1}',
                          fontWeight: 700,
                          fontSize: 24,
                        ),
                        FxSpacing.width(8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: !planStarted
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.saturation,
                                  ),
                                  child: Image.network(
                                    '$apiBaseUrl/api/v1/asset/object/campus_plan_picture/$planId?t=$cache',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/Ccvoccentbg.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  '$apiBaseUrl/api/v1/asset/object/campus_plan_picture/$planId?t=$cache',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/Ccvoccentbg.png',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * (isLocked ? 0.42 : 0.5),
                                    child: FxText.titleMedium(
                                      plan?.name ?? '',
                                      textScaleFactor: 1.2,
                                      fontWeight: 900,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  if (isLocked)
                                    const Icon(
                                      Icons.lock,
                                      color: Colors.red,
                                      size: 38,
                                    ),
                                ],
                              ),
                              FxSpacing.height(8),
                              if (plan?.description != null)
                                Row(
                                  children: [
                                    Expanded(
                                      child: FxText.titleSmall(
                                        '${plan?.description}',
                                        fontWeight: 800,
                                        maxLines: 4,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FxSpacing.height(16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          if (planStarted)
                            Flexible(
                              child: SizedBox(
                                height: 5,
                                child: (plan?.userPassedTopScore != null)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: mTheme.tertiary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      )
                                    : LiquidLinearProgressIndicator(
                                        value:
                                            (plan?.userPassingScore ?? 0) / 100,
                                        valueColor: AlwaysStoppedAnimation(
                                          mTheme.secondary,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        borderColor: Colors.red,
                                        borderWidth: 0,
                                        borderRadius: 8,
                                      ),
                              ),
                            ),
                          FxSpacing.width(8),
                          if (plan?.userPassedTopScore != null &&
                              plan?.userPassedTopScore != 0)
                            FxText.titleMedium(
                              '${plan?.userPassedTopScore?.toStringAsFixed(0)}',
                              color: mTheme.tertiary,
                              fontWeight: 700,
                              fontSize: 24,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
