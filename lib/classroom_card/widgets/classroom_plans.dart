import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/classroom_card/widgets/classroom_info_drawer.dart';
import 'package:voccent/classroom_card/widgets/classroom_plan.dart';
import 'package:voccent/classroom_card/widgets/clipper.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';

class ClassroomPlans extends StatefulWidget {
  const ClassroomPlans({
    super.key,
  });

  @override
  State<ClassroomPlans> createState() => _ClassroomPlansState();
}

class _ClassroomPlansState extends State<ClassroomPlans> {
  List<bool> isItemPassed = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final homeState = context.read<HomeCubit>().state;

    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: (context, state) {
        final scaffoldKey = GlobalKey<ScaffoldState>();
        final mTheme = Theme.of(context).colorScheme;
        final apiBaseUrl = context.read<ServerAddress>().httpUri;
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        final cache = context.read<ServerAddress>().cacheImgHash();
        isItemPassed =
            List.filled(state.classroom?.currentPlans?.length ?? 0, false);

        final imagePath =
            '/api/v1/asset/object/classroom_picture/${state.classroom?.classroom?.id}time=$cache';
        final bannerPath =
            '/api/v1/asset/object/classroom_banner/${state.classroom?.classroom?.id}?time=$cache';

        return Scaffold(
          key: scaffoldKey,
          endDrawer: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              color: isDarkTheme
                  ? FxAppTheme.theme.cardTheme.color
                  : mTheme.onPrimary.withOpacity(0.75),
              child: const ClassroomInfoDrawer(),
            ),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    size: 25,
                    color: mTheme.onSurface.withOpacity(1),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      FeatherIcons.messageCircle,
                    ),
                    color: mTheme.onSurface.withOpacity(1),
                    onPressed: () => GoRouter.of(context).push(
                      '/activity_chat',
                      extra: ActivityChatData(
                        operationId:
                            'classroom_${state.classroom?.classroom?.id}',
                        title: state.classroom?.classroom?.name ?? '',
                        imagePath: imagePath,
                        bannerPath: bannerPath,
                        adminId: state.classroom?.classroom?.createdby ?? '',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FeatherIcons.share2,
                    ),
                    color: mTheme.onSurface.withOpacity(1),
                    onPressed: () {
                      final size = MediaQuery.of(context).size;

                      Share.share(
                        '$apiBaseUrl/classroom/'
                        '${state.classroom?.classroom?.id}',
                        sharePositionOrigin: Rect.fromLTWH(
                          0,
                          0,
                          size.width,
                          size.height / 2,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(FeatherIcons.moreVertical),
                    color: mTheme.onSurface.withOpacity(1),
                    onPressed: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final isExpanded = constraints.biggest.height ==
                        MediaQuery.of(context).size.height * 0.3 +
                            MediaQuery.of(context).padding.top;

                    return FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: FxText.titleSmall(
                                  state.classroom?.classroom?.name ?? '',
                                  fontWeight: 700,
                                  textScaleFactor: 1.6257,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  color: mTheme.onSurface.withOpacity(1),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ),
                      background: ClipPath(
                        clipper: ClippingClass(),
                        child: SizedBox(
                          width: double.infinity,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 4,
                              sigmaY: 4,
                            ),
                            child: Image.network(
                              '$apiBaseUrl'
                              '/api/v1/asset/object/classroom_banner/'
                              '${state.classroom?.classroom?.id}'
                              '?time='
                              '$cache',
                              opacity: const AlwaysStoppedAnimation(.6),
                              errorBuilder: (context, error, stackTrace) {
                                return ClipPath(
                                  clipper: ClippingClass(),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    decoration: BoxDecoration(
                                      color: mTheme.primary,
                                    ),
                                  ),
                                );
                              },
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final itemLength =
                        state.classroom?.currentPlans?.length ?? 0;
                    final currentPlan = state.classroom?.currentPlans?[index];
                    final userPassingScore = currentPlan?.userPassingScore;
                    final userPassedTopScore = currentPlan?.userPassedTopScore;
                    var isLocked = true;

                    if (itemLength == 0) {
                      return Lottie.asset(
                        'assets/lottie/search.json',
                        height: 300,
                      );
                    } else {
                      if (homeState.classroomFocusId.isEmpty ||
                          homeState.pictureId.isEmpty) {
                        if (index == 0 ||
                            isItemPassed
                                .take(index)
                                .every((element) => element)) {
                          isLocked = false;
                        }

                        if (userPassingScore != null &&
                            userPassedTopScore != null) {
                          isItemPassed[index] =
                              userPassedTopScore >= userPassingScore;

                          if (isItemPassed[index]) {
                            isLocked = false;
                          }
                        }
                      } else {
                        isLocked = false;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 1),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, value, child) => AnimatedOpacity(
                            opacity: value,
                            duration: const Duration(milliseconds: 250),
                            child: Column(
                              children: [
                                if (index == 0)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomPaint(
                                      size: Size((width + 16) / 2, 75),
                                      painter: CurvedLinePainter(
                                        mTheme: mTheme,
                                        isMirror: true,
                                        progress: value,
                                      ),
                                    ),
                                  ),
                                ClassroomPlan(
                                  index: index,
                                  isLocked: isLocked,
                                ),
                                if (index < itemLength - 1)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomPaint(
                                      size: Size((width + 16) / 2, 75),
                                      painter: CurvedLinePainter(
                                        mTheme: mTheme,
                                        isMirror: index.isOdd,
                                        progress: value,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  childCount: state.classroom?.currentPlans?.length ?? 0 + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CurvedLinePainter extends CustomPainter {
  CurvedLinePainter({
    required this.mTheme,
    required this.progress,
    this.isMirror = false,
  });

  final bool isMirror;
  final ColorScheme mTheme;
  final double progress; // This now takes a progress value directly

  void _drawCurvedLine(Canvas canvas, Size size, Paint paint, bool isMirror) {
    final startPointX = isMirror ? size.width * 0.95 : size.width * 0.05;
    final controlPoint1X = isMirror ? size.width * 0.95 : size.width * 0.05;
    final controlPoint2X = isMirror ? size.width * 0.05 : size.width * 0.95;
    final endPointX = isMirror ? size.width * 0.05 : size.width * 0.95;

    final path = Path()..moveTo(startPointX, 0);
    final firstControlPoint = Offset(controlPoint1X, size.height * 0.95);
    final secondControlPoint = Offset(controlPoint2X, size.height * 0.05);
    final endPoint = Offset(endPointX, size.height);

    path.cubicTo(
      firstControlPoint.dx,
      firstControlPoint.dy * progress,
      secondControlPoint.dx,
      secondControlPoint.dy * progress,
      endPoint.dx,
      endPoint.dy * progress,
    );

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mTheme.onSurface.withOpacity(1)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    _drawCurvedLine(canvas, size, paint, isMirror);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
