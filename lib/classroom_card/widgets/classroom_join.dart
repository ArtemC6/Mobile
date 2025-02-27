import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/classroom_card/widgets/clipper.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';

class ClassroomJoin extends StatelessWidget {
  const ClassroomJoin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: _build,
    );
  }

  Widget _build(BuildContext context, ClassroomCardState state) {
    final mTheme = Theme.of(context).colorScheme;

    final langs = state.classroom?.languageIds != null
        ? Dictionary.languageNames(state.classroom?.languageIds ?? [])
        : '';

    final cache = context.read<ServerAddress>().cacheImgHash();

    return Scaffold(
      body: BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3 + 50,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: ClippingClass(),
                          child: SizedBox(
                            width: double.infinity,
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 4,
                                sigmaY: 4,
                              ),
                              child: Image.network(
                                '${context.read<ServerAddress>().httpUri}'
                                '/api/v1/asset/object/classroom_banner/'
                                '${state.classroom?.classroom?.id}'
                                '?time='
                                '$cache',
                                opacity: const AlwaysStoppedAnimation(.6),
                                errorBuilder: (context, error, stackTrace) {
                                  return ClipPath(
                                    clipper: ClippingClass(),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      decoration: BoxDecoration(
                                        color: mTheme.primary,
                                      ),
                                    ),
                                  );
                                },
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    FeatherIcons.chevronLeft,
                                    color: mTheme.onSurface.withOpacity(1),
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.error == null)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: mTheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '${context.read<ServerAddress>().httpUri}'
                                    '/api/v1/asset/object/'
                                    'classroom_picture/'
                                    '${state.classroom?.classroom?.id}'
                                    '?time='
                                    '$cache',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/Ccwhitebg.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (state.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: FxText.titleLarge(
                          '${state.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (langs != '')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.language_outlined,
                                        size: 25,
                                        color: mTheme.onBackground,
                                      ),
                                      FxSpacing.width(8),
                                      Flexible(
                                        child: FxText.bodyLarge(
                                          langs,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: FxText.bodyLarge(
                                  textAlign: TextAlign.center,
                                  '${S.current.genericParticipants}: '
                                  '${state.classroom?.classroom?.members ?? 0}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: FxText.bodyLarge(
                                  textAlign: TextAlign.center,
                                  '${S.current.classroomPlans}: '
                                  '${state.classroom?.classroom?.plans ?? 0}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: FxText.titleLarge(
                                  state.classroom?.classroom?.name ?? '',
                                  color: mTheme.onSurface.withOpacity(1),
                                  textAlign: TextAlign.center,
                                  fontWeight: 700,
                                  textScaleFactor: 1.2257,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: FxText.bodyLarge(
                                  state.classroom?.classroom?.description ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // !!! IMPORTANT
                    // cases (if have access): now => can do
                    // * no status (owner)
                    // * no status (not owner) => join
                    // * rejected by admin => rejoin
                    // * canceled by user => rejoin
                    // * invited by admin => confirm && cancel
                    // * resolved by admin => cancel membership
                    // * confirmed by user => cancel membership
                    // * requested by user => cancel
                    if (state.classroom?.confirmation?.status == null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: FxText.bodyMedium(
                          color: Theme.of(context).colorScheme.tertiary,
                          textAlign: TextAlign.center,
                          '',
                          fontWeight: 700,
                        ),
                      ),
                    if (state.classroom?.confirmation?.status == 'rejected' ||
                        state.classroom?.confirmation?.status == 'canceled')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: FxText.bodyMedium(
                          color: Theme.of(context).colorScheme.error,
                          textAlign: TextAlign.center,
                          '',
                          fontWeight: 700,
                        ),
                      ),

                    if (state.classroom?.confirmation?.status == 'invited' ||
                        state.classroom?.confirmation?.status == 'requested')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: FxText.bodyMedium(
                          color: Theme.of(context).colorScheme.secondary,
                          textAlign: TextAlign.center,
                          state.classroom?.confirmation?.status == 'invited'
                              ? S.current.classroomYouWereInvited
                              : S.current.classroomYouRequested2Join,
                          fontWeight: 700,
                        ),
                      ),
                    if ((state.classroom?.confirmation?.status == null &&
                            state.user.id !=
                                state.classroom?.classroom?.createdby) ||
                        state.classroom?.confirmation?.status == 'rejected' ||
                        state.classroom?.confirmation?.status == 'canceled')
                      FxContainer(
                        marginAll: 16,
                        color: mTheme.primary,
                        paddingAll: 16,
                        onTap: () {
                          if (state.loading == false) {
                            context.read<ClassroomCardCubit>().joinClassroom();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state.loading == true)
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            if (state.loading == false)
                              FxText.bodyLarge(
                                state.classroom?.classroom?.autoAccept ?? false
                                    ? S.current.join
                                    : S.current.classroomAsk2Join,
                                color: Colors.white,
                                fontWeight: 700,
                              ),
                          ],
                        ),
                      ),
                    if (state.classroom?.confirmation?.status == 'invited' ||
                        state.classroom?.confirmation?.status == 'requested')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              animationDuration: const Duration(
                                milliseconds: 1000,
                              ),
                              shadowColor:
                                  Theme.of(context).colorScheme.primary,
                              elevation: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              minimumSize: Size(
                                state.classroom?.confirmation?.status ==
                                        'invited'
                                    ? 120
                                    : 200,
                                70,
                              ),
                              maximumSize: Size(
                                state.classroom?.confirmation?.status ==
                                        'invited'
                                    ? 120
                                    : 200,
                                70,
                              ),
                            ),
                            onPressed: () {
                              if (state.loading == false) {
                                context
                                    .read<ClassroomCardCubit>()
                                    .cancelJoinClassroom();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (state.loading == true)
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                if (state.loading == false)
                                  FxText.bodyLarge(
                                    'Cancel',
                                    color: Colors.white,
                                    fontWeight: 700,
                                  ),
                              ],
                            ),
                          ),
                          if (state.classroom?.confirmation?.status ==
                              'invited') ...[
                            FxSpacing.width(8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                animationDuration: const Duration(
                                  milliseconds: 1000,
                                ),
                                shadowColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                minimumSize: const Size(120, 70),
                                maximumSize: const Size(120, 70),
                              ),
                              onPressed: () {
                                if (state.loading == false) {
                                  context
                                      .read<ClassroomCardCubit>()
                                      .confirmJoinClassroom();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (state.loading == true)
                                    const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  else
                                    FxText.bodyLarge(
                                      S.current.join,
                                      color: Colors.white,
                                      fontWeight: 700,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
