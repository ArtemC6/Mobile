// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';

class ClassroomInfoDrawer extends StatelessWidget {
  const ClassroomInfoDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: (context, state) {
        final langs = state.classroom?.languageIds != null
            ? Dictionary.languageNames(state.classroom?.languageIds ?? [])
            : '';
        final rating = state.classroom?.classroom?.rating;
        final apiBaseUrl = context.read<ServerAddress>().httpUri;
        final cache = context.read<ServerAddress>().cacheImgHash();
        final imagePath =
            '/api/v1/asset/object/classroom_picture/${state.classroom?.classroom?.id}?time=$cache';

        return Drawer(
          backgroundColor: isDarkTheme
              ? FxAppTheme.theme.cardTheme.color
              : mTheme.background,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 22, right: 22, top: 42),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '$apiBaseUrl$imagePath',
                          height: 180,
                          width: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.contain,
                            height: 180,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxSpacing.width(8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.titleLarge(
                                  state.classroom?.classroom?.name ?? '',
                                  color: mTheme.onSurface.withOpacity(1),
                                ),
                                FxSpacing.height(8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FxText.bodyMedium(
                                        state.classroom?.classroom
                                                ?.description ??
                                            '',
                                        color: mTheme.onSurface.withOpacity(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 21, top: 16, right: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language_outlined,
                            size: 25,
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                          FxSpacing.width(8),
                          Flexible(
                            child: FxText.bodyLarge(
                              langs,
                              color: mTheme.onSurface.withOpacity(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(16),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodyLarge(
                            textAlign: TextAlign.center,
                            '${S.current.genericParticipants}: '
                            '${state.classroom?.classroom?.members ?? 0}',
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                          FxSpacing.height(16),
                          FxText.bodyLarge(
                            textAlign: TextAlign.center,
                            '${S.current.classroomPlans}: '
                            '${state.classroom?.classroom?.plans ?? 0}',
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                          FxSpacing.height(16),
                          if (rating != null && rating != 0.0)
                            FxText.bodyLarge(
                              textAlign: TextAlign.center,
                              'Rating: '
                              '${state.classroom?.classroom?.rating}',
                              color: mTheme.onSurface.withOpacity(1),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FxContainer(
                  color: Colors.transparent,
                  onTap: () {
                    context.read<ClassroomCardCubit>().cancelJoinClassroom();
                    context.read<ClassroomCardCubit>().removeRecentClassroom(
                          '${state.classroom?.classroom?.id}',
                        );
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: FxText(
                      'Leave classroom',
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
