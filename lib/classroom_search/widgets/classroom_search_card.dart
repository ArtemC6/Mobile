import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/classroom_search/cubit/models/classroom_search_model.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/root/root_widget.dart';

class ClassroomSearchCard extends StatelessWidget {
  const ClassroomSearchCard({required this.card, this.user, super.key});

  final ClassroomSearchModel card;
  final User? user;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final cache = context.read<ServerAddress>().cacheImgHash();
    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/object/classroom_picture/${card.id}?time=$cache',
      height: 80,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/Ccwhitebg.png',
        fit: BoxFit.cover,
        height: 80,
        width: 80,
      ),
    );

    final langs = card.languageIds != null
        ? Dictionary.languageNames(card.languageIds!)
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: FxContainer(
        marginAll: 8,
        onTap: () {
          context
              .read<ClassroomSearchCubit>()
              .setRecentClassroom(card.id ?? '');
          GoRouter.of(context).push('/classroom_card/${card.id}');
        },
        child: Column(
          children: [
            Row(
              children: [
                FxContainer(
                  color: mTheme.onBackground,
                  paddingAll: 0,
                  clipBehavior: Clip.hardEdge,
                  child: img,
                ),
                FxSpacing.width(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                if (card.userStatus == 'resolved' ||
                                    card.userStatus == 'confirmed' ||
                                    user?.id == card.createdby)
                                  Icon(
                                    FeatherIcons.check,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 16,
                                  ),
                                if (card.userStatus == 'invited' ||
                                    card.userStatus == 'requested')
                                  Icon(
                                    Icons.hourglass_empty_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 16,
                                  ),
                                FxText.bodyLarge(
                                  (card.userStatus == 'resolved' ||
                                          card.userStatus == 'confirmed' ||
                                          user?.id == card.createdby ||
                                          card.userStatus == 'invited' ||
                                          card.userStatus == 'requested')
                                      ? '     ${card.name ?? ''}'
                                      : card.name ?? '',
                                  fontWeight: 600,
                                ),
                              ],
                            ),
                          ),
                          if ((card.rating ?? 0) > 0)
                            FxContainer(
                              color: mTheme.secondary.withAlpha(36),
                              padding: FxSpacing.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              borderRadiusAll: 4,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FeatherIcons.star,
                                    color: mTheme.secondary,
                                    size: 10,
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    (((card.rating ?? 0.0) * 10)
                                                .roundToDouble() /
                                            10)
                                        .toStringAsFixed(1),
                                    fontSize: 10,
                                    color: mTheme.secondary,
                                    fontWeight: 600,
                                  ),
                                  if ((card.countRating ?? 0) > 0)
                                    FxText.bodySmall(
                                      '/ ${card.countRating ?? 0}',
                                      fontSize: 7,
                                      color: mTheme.secondary,
                                      fontWeight: 500,
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (langs != '') ...[
                        FxSpacing.height(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.language_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withAlpha(140),
                              size: 16,
                            ),
                            FxSpacing.width(8),
                            Expanded(
                              child: FxText.bodySmall(
                                langs,
                                xMuted: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      FxSpacing.height(6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FxText.bodySmall(
                              '${S.current.genericParticipants}'
                              ': '
                              '${card.members ?? 0}',
                              xMuted: true,
                            ),
                          ),
                          FxSpacing.width(6),
                          Expanded(
                            child: FxText.bodySmall(
                              '${S.current.classroomPlans}'
                              ': '
                              '${card.plans ?? 0}',
                              xMuted: true,
                            ),
                          ),
                        ],
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
  }
}
