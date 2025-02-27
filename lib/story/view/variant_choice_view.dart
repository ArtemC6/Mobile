import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/models/item_pass_quiz.dart';
import 'package:voccent/story/cubit/models/story_current_pass.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/full_screen_background_video.dart';
import 'package:voccent/widgets/auto_text_control.dart';
import 'package:voccent/widgets/dialog.dart';

class VariantChoiceView extends StatefulWidget {
  const VariantChoiceView({super.key});

  @override
  State<VariantChoiceView> createState() => _VariantChoiceItemState();
}

class _VariantChoiceItemState extends State<VariantChoiceView>
    with SingleTickerProviderStateMixin {
  late final List<String> _selected;
  late AnimationController _animationController;

  final _scrollController = ScrollController();
  bool _showArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);

    _selected =
        context.read<StoryCubit>().state.currentPass!.itemPassQuiz?.quizId ??
            [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_checkScrollPosition)
      ..dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    if ((_scrollController.position.pixels + 50) >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showArrow = false;
      });
    } else {
      setState(() {
        _showArrow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final isDark = mTheme.brightness == Brightness.dark;

    return BlocConsumer<StoryCubit, StoryState>(
      listenWhen: (previous, current) =>
          previous.refPlayerStatus != current.refPlayerStatus ||
          previous.currentPass?.itemPassQuiz?.percent !=
                  current.currentPass?.itemPassQuiz?.percent &&
              current.currentPass?.itemPassQuiz?.percent != null,
      listener: (context, state) {
        state.refPlayerStatus == PlayerState.isPlaying
            ? _animationController.forward()
            : _animationController.reverse();

        if (state.currentPass?.itemPassQuiz?.percent != null) {
          final percent = state.currentPass?.itemPassQuiz?.percent;
          final xpAdd = state.currentPass?.comparison?.xpAdd ?? 0;

          showInfoDialog(
            context,
            percent! <= 33
                ? S.current.genericFairResult
                : percent <= 66
                    ? S.current.genericGoodResult
                    : S.current.genericExcellentResult,
            '${percent.toInt()}% / $xpAdd XP',
          );
        }
      },
      builder: (context, state) {
        if (state.isVideoOnBackground &&
            state.status == VideoLoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if ((state.currentPass!.itemQuizList ?? []).length < 3) {
            _showArrow = false;
          }

          final originalPhraseLength =
              (state.currentPass!.originalPhrase ?? '').length;

          return Stack(
            alignment: Alignment.center,
            children: [
              if (state.isVideoOnBackground)
                Positioned.fill(
                  child: FullScreenBackgroundVideo(
                    videoUrl:
                        '$apiBaseUrl/api/v1/asset/object/videosample/ref/${state.currentPass?.itemVideosamplerefid}',
                    looping: state.videosample?.loop ?? false,
                    volume: state.videosample?.volume ?? 0.5,
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 70, horizontal: 16),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if ((state.currentPass!.autoShow ?? false) ||
                          !state.isVideoOnBackground)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxSpacing.height(42),
                              if (state.currentPass!.translatedPhrase != null &&
                                  state.currentPass!.originalPhrase != null)
                                AnimatedOpacity(
                                  opacity: state.isNextScreen ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: TweenAnimationBuilder<int>(
                                    duration: state.audiosampleRefDuration >
                                            const Duration(seconds: 1)
                                        ? state.audiosampleRefDuration * 0.06
                                        : const Duration(seconds: 4),
                                    tween: IntTween(
                                      begin: 0,
                                      end: originalPhraseLength,
                                    ),
                                    builder: (
                                      BuildContext context,
                                      int value,
                                      child,
                                    ) =>
                                        Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      child: FxText(
                                        softWrap: true,
                                        (state.currentPass!.originalPhrase ??
                                                '')
                                            .substring(
                                          0,
                                          value.clamp(
                                            0,
                                            originalPhraseLength,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          letterSpacing: 0.1,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                FxText.displayMedium(
                                  state.currentPass!.originalPhrase ?? '',
                                  textAlign: TextAlign.center,
                                  color: mTheme.onSurface.withOpacity(1),
                                  fontWeight: 700,
                                  fontSize: 38,
                                ),
                            ],
                          ),
                        ),
                      FxSpacing.height(8),
                      if (state.currentPass!.itemAudiosamplerefid != null &&
                          state.currentPass!.itemQuizCount != 0)
                        Center(
                          child: ClipOval(
                            child: Material(
                              elevation: 5,
                              color: mTheme.primary,
                              child: IconButton(
                                splashColor: Colors.white,
                                iconSize: 28,
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _animationController,
                                  color: mTheme.onPrimary,
                                ),
                                onPressed: () =>
                                    context.read<StoryCubit>().playStopRef(),
                              ),
                            ),
                          ),
                        ),
                      FxSpacing.height(16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: (state.currentPass!.itemQuizList ?? [])
                            .map(
                              (e) => _questionOption(
                                e.variant ?? 'aa0675b0',
                                e.id ?? '2c43a34d',
                                state,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showArrow)
                Positioned(
                  right: 0,
                  bottom: 66,
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(
                      Icons.arrow_downward_outlined,
                      color: mTheme.onSurface.withOpacity(1),
                      size: 38,
                    ),
                    onPressed: () => _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          );
        }
      },
    );
  }

  Widget _questionOption(
    String option,
    String index,
    StoryState state,
  ) {
    final mTheme = Theme.of(context).colorScheme;

    double calculateHeight(String text) {
      final length = text.length;
      const baseHeight = 72.0;
      const extraHeightPerChar = 0.2;
      return baseHeight + (length * extraHeightPerChar).clamp(0, 300);
    }

    return GestureDetector(
      onTap: () {
        if (state.loading ||
            context.read<HomeCubit>().state.user.id !=
                state.currentPass!.userId) {
          return;
        }

        setState(() {
          if (state.currentPass!.type == ItemType.singleChoiceVariants) {
            _selected.clear();
          }

          if (_selected.contains(index)) {
            _selected.remove(index);
          } else {
            _selected.add(index);
          }

          context.read<StoryCubit>().chooseQuizVariant(
                ItemPassQuiz(
                  quizId: _selected,
                  quizText: const [],
                ),
              );
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selected.contains(index)
              ? mTheme.primary
              : mTheme.onPrimary.withOpacity(0.5),
          border: Border.all(
            color: mTheme.onPrimary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        padding: FxSpacing.fromLTRB(16, 8, 16, 8),
        margin: FxSpacing.fromLTRB(16, 4, 16, 16),
        child: Container(
          alignment: Alignment.center,
          height: calculateHeight(option),
          child: AutoSizeText(
            option,
            textScaleFactor: 1,
            wrapWords: AutoTextControl.shouldWrapWords(
              option,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              letterSpacing: 0.2,
              wordSpacing: 0.5,
              color: Colors.black,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  offset: const Offset(4, 4),
                  blurRadius: 12,
                  color: mTheme.primaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
