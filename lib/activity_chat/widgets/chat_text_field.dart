import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/activity_chat/widgets/list_of_hints.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _chatTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _chatTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final hints = ListOfHints.getRandomHints(3);
    return BlocConsumer<ActivityChatCubit, ActivityChatState>(
      listener: (context, state) {
        if (state.isEditingMode == true) {
          _chatTextController.text = state.editingMessageText!;
          _focusNode.requestFocus();
        }
      },
      builder: (context, state) {
        final isEditingMode = state.isEditingMode == true;
        const outlineInputBorder = OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              if (state.isVoccentAI && state.showHints)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final item = hints[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: mTheme.secondary.withOpacity(0.9),
                                    spreadRadius: 0.3,
                                    blurRadius: 3,
                                  ),
                                ],
                                border: Border.all(
                                  color: mTheme.secondary,
                                  width: 0.5,
                                ),
                                color: isDarkTheme
                                    ? FxAppTheme.theme.cardTheme.color
                                    : mTheme.onPrimary,
                              ),
                              child: FxContainer(
                                color: Colors.transparent,
                                borderRadiusAll: 16,
                                splashColor: mTheme.secondary.withOpacity(.5),
                                onTap: () {
                                  if (item == S.current.emotionAnalysis) {
                                    context
                                        .read<ActivityChatCubit>()
                                        .requestStreamotionButton();
                                  }
                                  context
                                      .read<ActivityChatCubit>()
                                      .sendMessageText(item);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: FxText.bodySmall(
                                    item,
                                    fontWeight: 700,
                                    color: mTheme.onSurface.withOpacity(1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                )
              else
                Container(),
              if (isEditingMode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            FeatherIcons.edit3,
                            size: 20,
                            color: mTheme.primary,
                          ),
                          FxSpacing.width(16),
                          FxText.bodyLarge(
                            S.current.genericEditing,
                            color: mTheme.primary,
                          ),
                          const Expanded(child: SizedBox()),
                          FxContainer(
                            color: Colors.transparent,
                            onTap: () {
                              VibrationController.onPressedVibration();
                              context
                                  .read<ActivityChatCubit>()
                                  .resetEditingMode();
                              _chatTextController.clear();
                            },
                            paddingAll: 8,
                            child: Icon(
                              FeatherIcons.x,
                              size: 20,
                              color: mTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: FxTextStyle.bodyMedium(
                          letterSpacing: 0.1,
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                        decoration: InputDecoration(
                          hintText: S.current.genericMessage,
                          hintStyle: FxTextStyle.bodyMedium(
                            letterSpacing: 0.1,
                            color: mTheme.onSurface.withOpacity(0.5),
                          ),
                          border: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          isDense: true,
                          contentPadding: FxSpacing.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: mTheme.background.withOpacity(0.5),
                        ),
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (message) async {
                          if (isEditingMode == true) {
                            await context
                                .read<ActivityChatCubit>()
                                .editMessageText(message);
                            _chatTextController.clear();
                          } else {
                            await context
                                .read<ActivityChatCubit>()
                                .sendMessageText(
                                  message,
                                );
                            _chatTextController.clear();
                          }
                        },
                        controller: _chatTextController,
                        focusNode: _focusNode,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    FxContainer(
                      paddingAll: 8,
                      borderRadiusAll: 32,
                      onTap: isEditingMode
                          ? () async {
                              VibrationController.onPressedVibration();
                              FocusScope.of(context).unfocus();
                              await context
                                  .read<ActivityChatCubit>()
                                  .editMessageText(_chatTextController.text);
                              _chatTextController.clear();
                            }
                          : () async {
                              VibrationController.onPressedVibration();

                              await context
                                  .read<ActivityChatCubit>()
                                  .sendMessageText(
                                    _chatTextController.text,
                                  );
                              _chatTextController.clear();
                            },
                      color: Colors.transparent,
                      child: isEditingMode
                          ? Icon(
                              FeatherIcons.check,
                              color: mTheme.primary,
                              size: 20,
                            )
                          : Icon(
                              FeatherIcons.send,
                              color: mTheme.primary,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
