import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/playlist/cubit/playlist_cubit.dart';
import 'package:voccent/widgets/dialog.dart';

class PlaylistResultBottomBar extends StatefulWidget {
  const PlaylistResultBottomBar({super.key});

  @override
  State<PlaylistResultBottomBar> createState() =>
      _PlaylistResultBottomBarState();
}

class _PlaylistResultBottomBarState extends State<PlaylistResultBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          Navigator.of(context).pop();
        }
      });
    super.initState();
  }

  Future<void> _showCustomDialog(String id) async {
    unawaited(_controller.forward());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) => _CustomDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistCubit, PlaylistState>(
      listenWhen: (previous, current) =>
          previous.myLastAttempt?.id != current.myLastAttempt?.id,
      listener: (context, state) {
        final result = state.myLastAttempt?.totalPercent;
        final xpAdd = state.myLastAttempt?.xpAdd ?? 0;

        if (result != null) {
          if (result >= 70) {
            _showCustomDialog(state.myLastAttempt?.id ?? '');
          }
          showInfoDialog(
            context,
            result <= 33
                ? S.current.genericFairResult
                : result <= 66
                    ? S.current.genericGoodResult
                    : S.current.genericExcellentResult,
            '${result.toInt()}% / $xpAdd XP',
          );
        }
      },
      builder: (context, attempt) {
        final cubit = context.read<PlaylistCubit>();
        final attempt = cubit.state.myLastAttempt;

        if (attempt != null) {
          return TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(
              milliseconds: 3000,
            ),
            builder: (BuildContext context, double val, Widget? child) {
              return Opacity(
                opacity: val,
                child: child,
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                RiveComparisonAnimation(
                  percentage: attempt.totalPercent,
                  artboard: 'confetti',
                  key: ValueKey(
                    attempt.totalPercent,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _CustomDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.12,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 92),
            child: Lottie.asset(
              'assets/lottie/medal.json',
              width: 300,
              height: 300,
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}
