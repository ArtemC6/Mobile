import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/debounce.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/models/item_pass_quiz.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/full_screen_background_video.dart';
import 'package:voccent/widgets/animation_widget.dart';

class TextInputView extends StatefulWidget {
  const TextInputView({super.key});

  @override
  State<TextInputView> createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputView>
    with SingleTickerProviderStateMixin {
  late List<String?> _answers;

  late AnimationController _animationController;
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    _answers = List<String?>.generate(
      context.read<StoryCubit>().state.currentPass!.itemQuizCount! + 1,
      (index) => null,
    );

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<StoryCubit, StoryState>(
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
            _textEditingController.clear();
          }
        },
        builder: (context, state) {
          final mTheme = Theme.of(context).colorScheme;
          final apiBaseUrl = context.read<ServerAddress>().httpUri;

          if (state.isVideoOnBackground &&
              state.status == VideoLoadingStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
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
                Container(
                  padding: FxSpacing.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FxSpacing.height(8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if ((state.currentPass!.itemSpelling ?? '')
                              .isNotEmpty)
                            Container(
                              alignment: Alignment.center,
                              child: AnimatedOpacity(
                                opacity: state.isNextScreen ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: TypewriterText(
                                  text: state.currentPass!.itemSpelling ?? '',
                                  duration: state.audiosampleRefDuration >
                                          const Duration(seconds: 1)
                                      ? state.audiosampleRefDuration * 0.06
                                      : const Duration(seconds: 4),
                                ),
                              ),
                            )
                          else
                            FxText.displayMedium(
                              '',
                              textAlign: TextAlign.center,
                              color: mTheme.onSurface.withOpacity(1),
                              fontWeight: 700,
                              fontSize: 38,
                            ),
                        ],
                      ),
                      FxSpacing.height(8),
                      if (state.currentPass!.itemAudiosamplerefid != null &&
                          state.currentPass!.itemQuizCount != 0)
                        ClipOval(
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
                      FxSpacing.height(16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: Iterable<int>.generate(
                          state.currentPass!.itemQuizMultiple ?? false
                              ? state.currentPass!.itemQuizCount!
                              : 1,
                        ).map((e) => textInput(e, state, mTheme)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      );

  Widget textInput(int index, StoryState state, ColorScheme mTheme) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: mTheme.onPrimary,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _textEditingController,
        style: FxTextStyle.titleMedium(
          color: mTheme.onPrimary,
        ),
        keyboardType: TextInputType.text,
        cursorColor: mTheme.onPrimary,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.transparent,
          isDense: true,
          filled: true,
          hintText:
              state.currentPass!.itemPassQuiz?.quizText?[index] ?? 'Answer',
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.titleMedium(
            color: mTheme.onPrimary,
            fontSize: 21,
          ),
          isCollapsed: true,
        ),
        enabled: !state.loading &&
            context.read<HomeCubit>().state.user.id ==
                state.currentPass!.userId,
        onChanged: (value) {
          Debounce().run(() {
            setState(() {
              _answers[index] = value;
            });

            context.read<StoryCubit>().chooseQuizVariant(
                  ItemPassQuiz(
                    quizId: const [],
                    quizText: _answers,
                  ),
                );
          });
        },
      ),
    );
  }
}
