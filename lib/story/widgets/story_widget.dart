import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/models/story_current_pass.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/view/act_title_view.dart';
import 'package:voccent/story/view/audio_comparison_view.dart';
import 'package:voccent/story/view/emotion_view.dart';
import 'package:voccent/story/view/foreign_link_view.dart';
import 'package:voccent/story/view/new_story_mode_selection_view.dart';
import 'package:voccent/story/view/new_story_view.dart';
import 'package:voccent/story/view/progressing_story_with_confitions_view.dart';
import 'package:voccent/story/view/result_view.dart';
import 'package:voccent/story/view/semantic_view.dart';
import 'package:voccent/story/view/text_input_view.dart';
import 'package:voccent/story/view/variant_choice_view.dart';
import 'package:voccent/story/widgets/next_button.dart';
import 'package:voccent/story/widgets/passing_story_widget.dart';
import 'package:voccent/story/widgets/story_pay_wall.dart';
import 'package:voccent/widgets/dialog.dart';

class StoryWidget extends StatefulWidget {
  const StoryWidget({
    this.planPassElementId,
    this.doneBtnVisibility,
    super.key,
  });

  final String? planPassElementId;
  final bool? doneBtnVisibility;

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _isOverlayVisible = true;
  bool _isOverlayVisibleLoading = true;
  Duration _audioSampleRefDuration = Duration.zero;

  late final _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelProgress(
        refDuration: _audioSampleRefDuration,
      ),
    ),
  );

  late final _overlayEntryLoading = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfo(
        infoText: S.current.wait,
      ),
    ),
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<StoryCubit>().pause();
    } else if (state == AppLifecycleState.resumed) {
      context.read<StoryCubit>().resume();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (!_isOverlayVisible && _overlayEntry.mounted && mounted) {
      _overlayEntry.remove();
    }

    if (_overlayEntryLoading.mounted && !_isOverlayVisibleLoading && mounted) {
      _overlayEntryLoading.remove();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final doneBtnVisibility = widget.doneBtnVisibility;

    return BlocConsumer<StoryCubit, StoryState>(
      listenWhen: (previous, current) =>
          previous.refPlayerStatus != current.refPlayerStatus ||
          previous.currentPass?.itemPassQuiz?.percent !=
                  current.currentPass?.itemPassQuiz?.percent &&
              current.currentPass?.itemPassQuiz?.percent != null ||
          previous.recorderStatus != current.recorderStatus ||
          previous.storyPass.status != current.storyPass.status ||
          previous.loading != current.loading ||
          previous.recorderError != current.recorderError,
      listener: (context, state) {
        if (state.storyPass.status == 'finished') {
          context.read<StoryCubit>().stopAll();
        }
        if (state.recordingAllowed == false) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                S.current.genericMicPermission,
              ),
              content: Text(
                S.current.genericAppNeedsMicAccess,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.current.genericDeny),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  onPressed: openAppSettings,
                  child: Text(S.current.genericSettings),
                ),
              ],
            ),
          );
        }

        final percent = state.currentPass?.comparison?.total ?? 0;
        final xpAdd = state.currentPass?.comparison?.xpAdd ?? 0;

        if (state.recorderStatus == RecorderState.isRecording &&
            _isOverlayVisible) {
          _isOverlayVisible = false;
          _audioSampleRefDuration = state.audiosampleRefDuration;
          Overlay.of(context).insert(_overlayEntry);
        } else {
          if (!_isOverlayVisible && mounted) {
            _isOverlayVisible = true;
            _overlayEntry.remove();
          }

          if (state.currentPass?.comparison?.total != null &&
              !state.loading &&
              _isOverlayVisible) {
            showInfoDialog(
              context,
              percent <= 33
                  ? S.current.genericFairResult
                  : percent <= 66
                      ? S.current.genericGoodResult
                      : S.current.genericExcellentResult,
              '${percent.toInt()}% / $xpAdd XP',
            );
          }
        }

        if (state.loading) {
          if (_isOverlayVisibleLoading && !_overlayEntryLoading.mounted) {
            Overlay.of(context).insert(_overlayEntryLoading);
            _isOverlayVisibleLoading = false;
          }
        } else {
          if (_overlayEntryLoading.mounted &&
              !_isOverlayVisibleLoading &&
              mounted) {
            _isOverlayVisibleLoading = true;
            _overlayEntryLoading.remove();
          }
        }

        if (state.storyPass.status == 'finished') {
          if (_overlayEntryLoading.mounted &&
              !_isOverlayVisibleLoading &&
              mounted) {
            _overlayEntryLoading.remove();
          }

          if (!_isOverlayVisible && _overlayEntry.mounted && mounted) {
            _overlayEntry.remove();
          }
        }
      },
      builder: (context, state) {
        if (!state.isInQuota) return const StoryPayWall();

        if (context.read<HomeCubit>().state.user.id == null ||
            state.storyPassUpdateTicketToken == null ||
            state.isAutoStart && state.currentPass == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: mTheme.secondary,
              ),
            ),
          );
        }
        return PopScope(
          canPop: state.recorderStatus != RecorderState.isRecording &&
              !state.loading,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
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
              title: state.currentPass?.type == ItemType.audioComparison ||
                      state.currentPass?.type ==
                          ItemType.singleChoiceVariants ||
                      state.currentPass?.type == ItemType.message ||
                      state.currentPass?.type == ItemType.singleTextInput ||
                      state.currentPass?.type == ItemType.multipleTextInputs ||
                      state.currentPass?.type == ItemType.actTitle ||
                      state.currentPass?.type ==
                          ItemType.multipleChoiceVariants ||
                      state.currentPass?.type == ItemType.foreignLink
                  ? Theme(
                      data: ThemeData(
                        colorScheme: const ColorScheme(
                          primary: Colors.transparent,
                          secondary: Colors.transparent,
                          surface: Colors.transparent,
                          background: Colors.transparent,
                          error: Colors.transparent,
                          onPrimary: Colors.transparent,
                          onSecondary: Colors.transparent,
                          onSurface: Colors.transparent,
                          onBackground: Colors.transparent,
                          onError: Colors.transparent,
                          brightness: Brightness.light,
                        ),
                      ),
                      child: AvatarStack(
                        height: 38,
                        avatars: state.storyPassCharacters.values
                            .map((e) => e.userId)
                            .toSet()
                            .map((userId) {
                          if (userId == null) {
                            return Image.asset(
                              'assets/images/Ccwhitebg.png',
                              fit: BoxFit.cover,
                            ).image;
                          } else {
                            return Image.network(
                              '$apiBaseUrl/api/v1/asset/object/user_avatar/$userId',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ).image;
                          }
                        }).toList(),
                      ),
                    )
                  : FxText.titleMedium(
                      S.current.contentStory.toUpperCase(),
                      fontWeight: 700,
                      textScaleFactor: 1.2257,
                      color: mTheme.primary,
                    ),
              actions: [
                if (state.currentPass?.actBackgroundAudiosampleRefId != null)
                  IconButton(
                    onPressed: () =>
                        context.read<StoryCubit>().muteUnmuteBackground2(),
                    icon: state.isback2Unmuted
                        ? const Icon(Icons.volume_up)
                        : const Icon(Icons.volume_off),
                    color: mTheme.error,
                  ),
                if (state.storyPass.status != 'new' &&
                    !context.read<AuthCubit>().state.isFirstRun)
                  IconButton(
                    onPressed: () => startOverDialogBlur(
                      context,
                      state,
                      widget.planPassElementId,
                    ),
                    icon: const Icon(FeatherIcons.rotateCw),
                    color: mTheme.error,
                  ),
                if (state.storyPass.status == 'new')
                  IconButton(
                    onPressed: () {
                      final apiBaseUrl = context.read<ServerAddress>().httpUri;
                      final size = MediaQuery.of(context).size;
                      Share.share(
                        '$apiBaseUrl/try/story-pass/'
                        // ignore: lines_longer_than_80_chars
                        '${context.read<StoryCubit>().state.storyPass.storyParentId}',
                        sharePositionOrigin: Rect.fromLTWH(
                          0,
                          0,
                          size.width,
                          size.height / 2,
                        ),
                      );
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(FeatherIcons.share2),
                    ),
                    color: mTheme.onBackground,
                  ),
                if (!context.read<AuthCubit>().state.isFirstRun)
                  IconButton(
                    icon: const Icon(
                      FeatherIcons.messageCircle,
                    ),
                    color: mTheme.onBackground,
                    onPressed: () => GoRouter.of(context).push(
                      '/activity_chat',
                      extra: ActivityChatData(
                        operationId: 'storypass_${state.storyPass.id}',
                        title: state.story?.name ?? '',
                        imagePath: '/api/v1/asset/object/'
                            'story_picture/${state.story!.id}',
                        bannerPath: '/api/v1/asset/object/'
                            'story_picture/${state.story!.id}',
                      ),
                    ),
                  ),
              ],
            ),
            body: _body(context, state, doneBtnVisibility),
            bottomNavigationBar: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Visibility(
                visible: state.storyPass.progress != 0,
                child: _BrickProgressBar(),
              ),
            ),
          ),
        );
      },
    );
  }

  double _zeroOrPositive(double number) {
    return number < 0 ? 0 : number;
  }

  Widget _body(
    BuildContext context,
    StoryState state,
    bool? doneBtnVisibility,
  ) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final percent = state.currentPass?.itemPassQuiz?.percent ??
        state.currentPass?.comparison?.total;
    final blurPercent = percent ?? 0.0;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final actId = state.currentPass?.actId;

    return Stack(
      children: [
        if (state.storyPass.status == 'new')
          Column(
            children: [
              if (state.storyPass.type != null)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 2,
                          sigmaY: 2,
                        ),
                        child: Image.network(
                          '$apiBaseUrl/api/v1/asset/object/'
                          'story_picture/${state.story!.id}',
                          fit: BoxFit.cover,
                          errorBuilder: (p0, p1, p2) => const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (actId != null && state.storyPass.status == 'passing')
          Column(
            children: [
              if (state.currentPass?.type == ItemType.foreignLink ||
                  state.isInteractiveVideo ||
                  state.isVideoOnBackground)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      color: mTheme.background,
                    ),
                  ),
                )
              else if (state.isImageOnBackground)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      '$apiBaseUrl/api/v1/asset/object/'
                      'story_act_item_picture/${state.currentPass?.itemId}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/Ccwhitebg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: _zeroOrPositive(14 - blurPercent / 5),
                              sigmaY: _zeroOrPositive(14 - blurPercent / 5),
                            ),
                            child: Image.network(
                              '$apiBaseUrl/api/v1/asset/object/story_act_picture/$actId',
                              opacity: const AlwaysStoppedAnimation(.62),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                        const _AnimationBackground(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.transparent,
                                if (isDarkTheme) Colors.black else Colors.white,
                              ],
                              stops: const [0.2, 0.9],
                              radius: 1, // Increased radius
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        switch (state.storyPass.status) {
          'new' => state.storyPass.type == null
              ? const NewStoryModeSelectionView()
              : const NewStoryView(),
          'passing' =>
            _passingStoryView(context, state, widget.planPassElementId),
          'finished' => ResultView(doneBtnVisibility: doneBtnVisibility),
          _ => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
        },
        RiveComparisonAnimation(
          percentage: percent,
          artboard: 'confetti',
          key: ValueKey(
            blurPercent,
          ),
        ),
        if (!state.isInQuota) const StoryPayWall(),
      ],
    );
  }

  Widget _passingStoryView(
    BuildContext context,
    StoryState state,
    String? planPassElementId,
  ) {
    Widget wrapContent(Widget content) {
      final options = content is PassingStoryOptionsProvider
          ? content as PassingStoryOptionsProvider
          : const PassingStoryOptionsProvider();
      final nextButton = NextButton(planPassElementId: planPassElementId);
      final Widget view;

      view = Stack(
        children: [
          Positioned.fill(child: content),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: !state.isNextScreen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: nextButton,
            ),
          ),
        ],
      );

      return PassingStoryWidget(options: options, child: view);
    }

    final content = state.currentPass != null
        ? state.currentPass!.actConditions?.isNotEmpty ?? false
            ? const ProgressingStoryWithConditionsView()
            : switch (state.currentPass!.type) {
                ItemType.audioComparison => const AudioComparisonView(),
                ItemType.singleChoiceVariants => const VariantChoiceView(),
                ItemType.multipleChoiceVariants => const VariantChoiceView(),
                ItemType.message => const VariantChoiceView(),
                ItemType.singleTextInput => const TextInputView(),
                ItemType.multipleTextInputs => const TextInputView(),
                ItemType.actTitle => const ActTitleView(),
                ItemType.foreignLink => const ForeignLinkView(),
                ItemType.emotionAnalysis => const EmotionAnalysisView(),
                ItemType.semanticAnalysis => const SemanticAnalysisView(),
              }
        : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
    return wrapContent(content);
  }
}

class _AnimationBackground extends StatefulWidget {
  const _AnimationBackground();

  @override
  _AnimationBackgroundState createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<_AnimationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: -0, end: 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Experiment with different curves
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
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  if (Theme.of(context).brightness == Brightness.dark)
                    Colors.black
                  else
                    Colors.white,
                ],
                stops: const [0.2, 0.9],
                radius: _animation.value, // Increased radius
              ),
            ),
          );
        },
      );
}

class _BrickProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final totalLevels = state.storyPass.levels ?? 0;
        final currentLevel = state.storyPass.levelNumber ?? 0;
        final totalItemsInLevel = state.storyPass.actItems ?? 0;
        final currentItemInLevel = state.storyPass.actItemNumber ?? 0;

        final levelBricks = List<Widget>.generate(
          totalLevels,
          (index) {
            final isCurrentLevel = index == currentLevel - 1;
            final color = index < currentLevel - 1
                ? mTheme.secondary.withOpacity(0.9)
                : Colors.transparent;

            final itemBricks = isCurrentLevel
                ? List<Widget>.generate(
                    totalItemsInLevel,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 5,
                          decoration: BoxDecoration(
                            color: index < currentItemInLevel - 1
                                ? mTheme.secondary.withOpacity(0.9)
                                : Colors.transparent,
                            border: Border.all(
                              color: mTheme.secondary.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : <Widget>[];

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: mTheme.secondary.withOpacity(0.7),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isCurrentLevel) ...[
                            Row(children: itemBricks),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        return Row(children: levelBricks);
      },
    );
  }
}
