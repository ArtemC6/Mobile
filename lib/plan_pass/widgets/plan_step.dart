// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/challenge/view/challenge_page.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/plan_pass/cubit/models/plan_pass_model.dart';
import 'package:voccent/plan_pass/cubit/plan_pass_cubit.dart';
import 'package:voccent/plan_pass/plan_pass_data.dart';
import 'package:voccent/plan_pass/widgets/restart_dialog.dart';
import 'package:voccent/plan_pass/widgets/url_view.dart';
import 'package:voccent/playlist/view/playlist_page.dart';
import 'package:voccent/story/view/story_view.dart';

class PlanStep extends StatelessWidget {
  const PlanStep({required this.planPassData, super.key});

  final PlanPassData? planPassData;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<PlanPassCubit, PlanPassState>(
      builder: (context, state) {
        if (state.user.id == null || state.loaded == false) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: mTheme.primary,
              ),
            ),
          );
        }

        final element =
            state.pass?.elements![state.step] ?? PlanPassElementModel();

        final elementCount = state.pass?.elements?.length ?? 0;

        final Widget child;

        if (elementCount == 0) {
          child = FxText('No elements');
        } else {
          switch (element.type) {
            case 'challenge':
              child = ChallengePageById(
                challengeId: element.objectId!,
                nextBtnVisibility: false,
                key: ValueKey(element.objectId!),
              );
            case 'playlist':
              child = PlaylistPageById(
                playlistId: element.objectId!,
                key: ValueKey(element.objectId!),
              );
            case 'story':
              child = StoryView(
                storyId: element.objectId!,
                planPassElementId: element.id,
                doneBtnVisibility: false,
                key: ValueKey(element.objectId!),
              );
            default:
              child = UrlView(
                element.other!,
                key: ValueKey(element.other!),
              );
              break;
          }
        }

        return Scaffold(
          body: Column(
            children: [
              Expanded(child: child),
              BottomBar(
                planPassData: planPassData,
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    this.planPassData,
  });
  final PlanPassData? planPassData;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<PlanPassCubit, PlanPassState>(
      builder: (context, state) {
        final currentStep = state.step;
        final elementCount = state.pass?.elements?.length ?? 0;
        final passId = state.pass?.pass?.id ?? '';

        final planContainsStory = state.planContainsStory ?? false;
        final cubit = planPassData?.classroomCardCubit;
        final index = planPassData?.index ?? 0;

        final plan = cubit?.state.classroom?.currentPlans?[index];
        final planId = plan?.planId;
        final classroomId = plan?.classroomId;

        void onStartAgainPressed() {
          GoRouter.of(context).pushReplacement(
            '/plan_pass/$planId/$classroomId/false',
            extra: PlanPassData(
              classroomCardCubit: cubit!,
              index: index,
            ),
          );
        }

        return Material(
          child: SafeArea(
            top: false,
            child: FxContainer(
              paddingAll: 0,
              marginAll: 0,
              color: mTheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: (state.step > 0)
                        ? FxButton.block(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                FeatherIcons.chevronsLeft,
                                color: mTheme.onBackground,
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              context.read<PlanPassCubit>().prevStep();
                              cubit?.setCode(
                                cubit.state.classroom?.classroom?.id,
                                null,
                              );
                              cubit?.fetchClassroom(
                                context.read<HomeCubit>().state.user,
                              );
                            },
                          )
                        : Container(),
                  ),
                  FxSpacing.width(8),
                  Expanded(
                    child: FxButton.block(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          FeatherIcons.rotateCw,
                          color: mTheme.onBackground,
                          size: 25,
                        ),
                      ),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (notThisContext) => Platform.isIOS
                              ? RestartIosDialog(
                                  onStartAgainPressed: onStartAgainPressed,
                                  planName: plan?.name ?? '',
                                )
                              : RestartAndroidDialog(
                                  onStartAgainPressed: onStartAgainPressed,
                                  planName: plan?.name ?? '',
                                ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: FxButton.block(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.list,
                          size: 30,
                          color: mTheme.onBackground,
                        ),
                      ),
                      onPressed: () => _showBottomSheet(context, state),
                    ),
                  ),
                  Expanded(
                    child: (currentStep < elementCount - 1)
                        ? FxButton.block(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                FeatherIcons.chevronsRight,
                                color: mTheme.primary,
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              context.read<PlanPassCubit>().nextStep();
                              cubit?.setCode(
                                cubit.state.classroom?.classroom?.id,
                                null,
                              );
                              cubit?.fetchClassroom(
                                context.read<HomeCubit>().state.user,
                              );
                            },
                          )
                        : FxButton.block(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                FeatherIcons.check,
                                color: mTheme.tertiary,
                                size: 30,
                              ),
                            ),
                            onPressed: () async {
                              if (planContainsStory) {
                                await showDialog<void>(
                                  context: context,
                                  builder: (notThisContext) => Platform.isIOS
                                      ? _finishPlanIosDialog(
                                          context,
                                          passId,
                                        )
                                      : _finishPlanDialog(
                                          context,
                                          passId,
                                        ),
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(
    BuildContext context,
    PlanPassState state,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final mTheme = Theme.of(context).colorScheme;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: mTheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FxSpacing.height(16),
                  FxText.titleLarge(
                    state.pass?.pass?.planName ?? '',
                    fontWeight: 600,
                    color: mTheme.secondary,
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(4),
                  FxText.titleMedium(
                    state.pass?.pass?.planDescription ?? '',
                    fontWeight: 600,
                    xMuted: true,
                    color: mTheme.onSurface.withOpacity(1),
                    textAlign: TextAlign.center,
                  ),
                  FxSpacing.height(16),
                  Divider(
                    color: mTheme.primary,
                    thickness: 0.2,
                  ),
                  FxSpacing.height(16),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: state.pass?.elements?.length ?? 0,
                      itemBuilder: (context, index) {
                        final element = state.pass?.elements![index];

                        final elementType = {
                              'story': S.current.contentStory,
                              'playlist': S.current.contentPlaylist,
                              'challenge': S.current.contentChallenge,
                            }[element?.type?.toLowerCase()] ??
                            '';

                        final currentElement =
                            element?.id == state.pass!.elements![state.step].id;
                        return Column(
                          children: [
                            Row(
                              children: [
                                FxText.bodyLarge(
                                  '${index + 1}',
                                  fontWeight: 600,
                                  color: currentElement
                                      ? mTheme.primary.withOpacity(1)
                                      : mTheme.onSurface.withOpacity(1),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FxText.titleMedium(
                                        element?.objectName ?? '',
                                        fontWeight: 600,
                                        color: currentElement
                                            ? mTheme.primary.withOpacity(1)
                                            : mTheme.onSurface.withOpacity(1),
                                      ),
                                      if (element?.description != null)
                                        FxText.titleSmall(
                                          element?.description ?? '',
                                          fontWeight: 600,
                                          textAlign: TextAlign.justify,
                                          xMuted: true,
                                          color: currentElement
                                              ? mTheme.primary.withOpacity(1)
                                              : mTheme.onSurface.withOpacity(1),
                                        ),
                                      FxText.titleSmall(
                                        elementType,
                                        textAlign: TextAlign.justify,
                                        xMuted: true,
                                        color: currentElement
                                            ? mTheme.primary.withOpacity(1)
                                            : mTheme.onSurface.withOpacity(1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FxSpacing.height(8),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _finishPlanDialog(
    BuildContext context,
    String passId,
  ) {
    final mTheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: FxSpacing.all(20),
        decoration: BoxDecoration(
          color: mTheme.background,
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
                      S.current.finishPlan,
                      fontWeight: 600,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              margin: FxSpacing.only(top: 16),
              child: FxText.titleMedium(
                S.current.finishPlanConfirmation,
              ),
            ),
            Container(
              margin: FxSpacing.top(8),
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FxButton.text(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: FxText.bodyMedium(
                      S.current.genericCancel,
                      fontWeight: 600,
                      color: mTheme.primary,
                    ),
                  ),
                  FxButton(
                    backgroundColor: mTheme.primary,
                    borderRadiusAll: 4,
                    elevation: 0,
                    onPressed: () async {
                      await context.read<PlanPassCubit>().finishPlanPass();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: FxText.bodyMedium(
                      'OK',
                      fontWeight: 600,
                      color: mTheme.onPrimary,
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

  Widget _finishPlanIosDialog(
    BuildContext context,
    String passId,
  ) {
    final mTheme = Theme.of(context).colorScheme;
    return CupertinoAlertDialog(
      title: FxText.titleLarge(
        S.current.finishPlan,
        fontWeight: 700,
        color: mTheme.onSurface.withOpacity(1),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(S.current.finishPlanConfirmation),
      ),
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
          onPressed: () async {
            await context.read<PlanPassCubit>().finishPlanPass();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(S.current.genericFinish),
        ),
      ],
    );
  }
}
