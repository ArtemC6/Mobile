import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/activity_chat/widgets/ai_is_typing_widget.dart';
import 'package:voccent/activity_chat/widgets/feed_search_result.dart';
import 'package:voccent/activity_chat/widgets/message_widget.dart';
import 'package:voccent/activity_chat/widgets/streamotion_chat_button.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget(
    this.adminId, {
    super.key,
  });
  final String adminId;

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  final ValueNotifier<bool> _showScrollToBottomButton =
      ValueNotifier<bool>(false);
  Map<String, GlobalKey> messageKeys = {};
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      VibrationController.stopHeartbeatVibration();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height * 0.3;

    if (currentScroll <= delta) {
      if (_showScrollToBottomButton.value) {
        _showScrollToBottomButton.value = false;
      }
    } else {
      if (!_showScrollToBottomButton.value) {
        _showScrollToBottomButton.value = true;
      }
    }

    if (maxScroll - currentScroll <= delta) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 150), () {
        context.read<ActivityChatCubit>().getMessages();
      });
    }
  }

  void _scrollToBottom() {
    VibrationController.onPressedVibration();
    _scrollController
        .animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      if (_showScrollToBottomButton.value) {
        _showScrollToBottomButton.value = false;
      }
    });
  }

  void scrollToMessage(String messageId) {
    final key = messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    VibrationController.stopHeartbeatVibration();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<HomeCubit>().state.user;
    final mTheme = Theme.of(context).colorScheme;
    final scrollToBottomButton = AnimationConfiguration.staggeredList(
      position: 0,
      child: FadeInAnimation(
        duration: const Duration(
          milliseconds: 500,
        ),
        child: ValueListenableBuilder(
          valueListenable: _showScrollToBottomButton,
          builder: (context, value, _) => value
              ? FxContainer.rounded(
                  onTap: _scrollToBottom,
                  child: Icon(
                    Icons.expand_more,
                    color: mTheme.onSurface.withOpacity(1),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );

    return BlocConsumer<ActivityChatCubit, ActivityChatState>(
      listener: (context, state) {
        if (state.isVoccentAI && state.isTyping) {
          VibrationController.startHeartbeatVibration();
        } else if (state.isVoccentAI && !state.isTyping) {
          VibrationController.stopHeartbeatVibration();
        }
        if (state.newMessageID.isNotEmpty) {
          scrollToMessage(state.newMessageID);
        }
      },
      builder: (context, state) {
        final list = <Widget>[];

        for (var i = 0; i < state.messages.length; i++) {
          final message = state.messages[i];
          final theirMessage = user.id != message.createdby;
          final adminMessage = message.createdby == widget.adminId;

          list.add(
            MessageWidget(
              adminMessage: adminMessage,
              theirMessage: theirMessage,
              message: message,
            ),
          );
        }
        if (state.isVoccentAI && state.isTyping) {
          list.add(
            const AIIsTypingWidget(),
          );
        }
        if (state.isVoccentAI && state.query != '') {
          list.add(
            BlocSelector<ActivityChatCubit, ActivityChatState, String>(
              selector: (state) => state.query,
              builder: (context, query) {
                return FeedSearchResult(
                  key: ValueKey(query),
                  query: query,
                );
              },
            ),
          );
        }
        if (state.isVoccentAI && state.showStreamotionButton == true) {
          list.add(
            const StreamotionChatButton(),
          );
        }

        switch (state.status) {
          case Status.initial:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Status.loading:
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Status.ready:
            return Expanded(
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    reverse: true,
                    padding: FxSpacing.x(16),
                    children: UnmodifiableListView(list.reversed),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: scrollToBottomButton,
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
