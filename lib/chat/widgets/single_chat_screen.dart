// ignore_for_file: deprecated_member_use

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:voccent/chat/cubit/chat_cubit.dart';
import 'package:voccent/chat/cubit/models/message/message.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/cubit/models/user/user.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';

class SingleChatScreen extends StatefulWidget {
  const SingleChatScreen(this.chatId, {super.key});

  final String chatId;

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final TextEditingController _chatTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    context.read<ChatCubit>().openChat(widget.chatId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _chatTextController.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<ChatCubit, ChatState>(
        listenWhen: (previous, current) {
          return previous.user.id == null && current.user.id != null;
        },
        listener: (context, state) {
          context.read<ChatCubit>().openChat(widget.chatId);
        },
        builder: (context, state) {
          return PopScope(
            onPopInvoked: (didPop) {
              context.read<ChatCubit>().resetMessages();
            },
            child: _buildBody(context, state),
          );
        },
      );

  Widget _buildMessageList(
    User user,
    ChatState state,
    ColorScheme mTheme,
    ThemeData theme,
  ) {
    final list = <Widget>[];

    for (var i = 0; i < state.messages.length; i++) {
      list.add(
        _buildSingleMessage(
          user,
          state.messages[i],
          mTheme,
          theme,
        ),
      );
    }

    if (_scrollController.positions.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.positions.isNotEmpty) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    }

    return ListView(
      controller: _scrollController,
      reverse: true,
      padding: FxSpacing.x(20),
      children: UnmodifiableListView(list.reversed),
    );
  }

  Widget _buildSingleMessage(
    User user,
    Message message,
    ColorScheme mTheme,
    ThemeData theme,
  ) {
    final theirMessage = user.id != message.createdby;
    return Align(
      alignment: theirMessage ? Alignment.centerLeft : Alignment.centerRight,
      child: FxContainer(
        color: mTheme.primary.withAlpha(30),
        paddingAll: 12,
        borderRadiusAll: 16,
        margin: FxSpacing.y(8),
        bordered: true,
        border: Border.all(
          color: theirMessage
              ? mTheme.primary.withAlpha(30)
              : mTheme.secondary.withAlpha(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              theirMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            for (final i in message.meta)
              if (i.type == 'invitation_classroom' ||
                  i.type == 'invitation_campus') ...[
                FxSpacing.height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => context
                            .read<ChatCubit>()
                            .joinConfirmOrCancel(i, false),
                        child: FxContainer.bordered(
                          child:
                              Center(child: FxText.bodyLarge(S.current.cancel)),
                        ),
                      ),
                    ),
                    FxSpacing.width(8),
                    Expanded(
                      child: InkWell(
                        onTap: () => context
                            .read<ChatCubit>()
                            .joinConfirmOrCancel(i, true),
                        child: FxContainer(
                          color: mTheme.primary,
                          child: Center(
                            child: FxText.bodyLarge(
                              S.current.confirm,
                              color: mTheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (i.type == 'invitation_story' ||
                  i.type == 'story_player_poke') ...[
                FxSpacing.height(2.12341),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final payload =
                              jsonDecode(i.payload!) as Map<String, dynamic>;
                          GoRouter.of(context).go(
                            '/story-pass/${payload['StoryParentID']}?l=${payload['Link']}',
                          );
                        },
                        child: FxContainer(
                          color: mTheme.secondary,
                          bordered: true,
                          border: Border.all(color: mTheme.onTertiary),
                          child: Center(
                            child: FxText.bodyLarge(
                              S.current.passTheStory,
                              color: mTheme.onTertiary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (i.type == 'mixer_need_repeat') ...[
                FxSpacing.height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          GoRouter.of(context).go(
                            '/mixer/',
                          );
                        },
                        child: FxContainer(
                          color: mTheme.primary,
                          bordered: true,
                          border: Border.all(color: mTheme.onTertiary),
                          child: Center(
                            child: FxText.bodyLarge(
                              '${S.current.open} Mixer',
                              color: mTheme.onTertiary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side (existing content)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${message.username} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mTheme.onSurface.withOpacity(1),
                                  ),
                                ),
                                TextSpan(
                                  text: Intl().date().format(
                                        DateTime.parse(message.createdat!),
                                      ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mTheme.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FxSpacing.height(18),
                          FxText.bodySmall(
                            i.body ?? '',
                            fontSize: 20,
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                          FxSpacing.height(18),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;
    final user = context.read<HomeCubit>().state.user;
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;

    if (state.uiLoading) {
      return Scaffold(
        body: Padding(
          padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
          child: LoadingEffect.getSearchLoadingScreen(context, theme),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxSpacing.width(weight / 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxText.bodyMedium(
                        state.currentChat?.subjectName ?? '',
                        fontWeight: 800,
                        fontSize: height / 50,
                        color: mTheme.onSurface.withOpacity(1),
                      ),
                      if (state.currentChat?.type != 'system_personal')
                        FxText.bodySmall(
                          state.currentChat?.firstFourUsernames ?? '',
                          muted: true,
                          fontSize: 10,
                          color: mTheme.onBackground,
                        ),
                    ],
                  ),
                  FxContainer.rounded(
                    paddingAll: 0,
                    margin: const EdgeInsets.only(right: 16, bottom: 6),
                    child: state.currentChat?.firstUserpic != null
                        ? Image.network(
                            '${context.read<ServerAddress>().httpUri}'
                            '${state.currentChat?.firstUserpic}',
                            height: 38,
                            width: 38,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/Ccvoccentbg.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/Ccvoccentbg.png',
                            height: 38,
                            width: 38,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            FxSpacing.height(12),
            Expanded(child: _buildMessageList(user, state, mTheme, theme)),
            if (state.currentChat?.type != 'system_personal') ...[
              Padding(
                padding:
                    FxSpacing.only(left: 22, right: 22, bottom: 22, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: FxTextStyle.bodyMedium(
                          letterSpacing: 0.1,
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                        decoration: InputDecoration(
                          hintText: S.current.genericTypeHere,
                          hintStyle: FxTextStyle.bodyMedium(
                            letterSpacing: 0.1,
                            color: mTheme.onSurface.withOpacity(1),
                            muted: true,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.4,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.4,
                            ),
                          ),
                          isDense: true,
                          contentPadding: FxSpacing.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (message) async {
                          await context
                              .read<ChatCubit>()
                              .sendMessageText(message);

                          _chatTextController.clear();
                        },
                        controller: _chatTextController,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    FxContainer.rounded(
                      margin: FxSpacing.left(16),
                      width: 38,
                      onTap: () async {
                        await context
                            .read<ChatCubit>()
                            .sendMessageText(_chatTextController.text);

                        _chatTextController.clear();
                      },
                      height: 38,
                      padding: FxSpacing.left(
                        _chatTextController.text.isEmpty ? 0 : 4,
                      ),
                      color: theme.colorScheme.primary.withAlpha(28),
                      child: Icon(
                        FeatherIcons.send,
                        color: theme.colorScheme.primary,
                        size: _chatTextController.text.isEmpty ? 20 : 18,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...<Widget>[
              const SizedBox(
                height: 20,
              ),
            ],
          ],
        ),
      );
    }
  }
}
