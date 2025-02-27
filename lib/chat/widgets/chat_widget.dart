import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/chat/cubit/chat_cubit.dart';
import 'package:voccent/chat/cubit/models/chat/chat.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/support_button_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, this.channel});
  final FeedModel? channel;
  @override
  Widget build(BuildContext context) => BlocBuilder<ChatCubit, ChatState>(
        builder: _buildBody,
      );

  Widget _buildBody(BuildContext context, ChatState state) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    if (state.uiLoading) {
      return Scaffold(
        body: LoadingEffect.getSearchLoadingScreen(context, Theme.of(context)),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              FeatherIcons.chevronLeft,
              size: 25,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          centerTitle: true,
          title: FxText.titleMedium(
            S.current.messenger.toUpperCase(),
            fontWeight: 700,
            textScaleFactor: 1.2257,
            color: mTheme.onPrimaryContainer,
          ),
        ),
        body: Column(
          children: [
            FxSpacing.height(12),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: FxSpacing.zero,
                children: _buildChatList(context, state),
              ),
            ),
          ],
        ),
        floatingActionButton: SupportButtonWidget(
          user: state.user,
        ),
      );
    }
  }

  List<Widget> _buildChatList(BuildContext context, ChatState state) {
    final list = <Widget>[];

    for (final chat in state.chats) {
      if (chat.type == 'system_personal') {
        list.add(_buildSystemChat(context, chat));
      } else {
        list.add(_buildSingleChat(context, chat));
      }
    }

    return list;
  }

  Widget _buildSingleChat(BuildContext context, Chat chat) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;
    final pic = channel?.object?.asset?.channelAvatar?[0];
    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/file/channel_avatar/$pic',
      height: 40,
      width: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/content-types/channels.jpeg',
        height: 40,
        width: 40,
        fit: BoxFit.cover,
      ),
    );

    return FxContainer(
      onTap: () => GoRouter.of(context).go('/chatroom/${chat.id}'),
      margin: FxSpacing.nTop(12),
      paddingAll: 8,
      borderRadiusAll: 12,
      borderColor: mTheme.primary,
      bordered: chat.messageStatus != 'read',
      color: Colors.transparent,
      child: Row(
        children: [
          FxContainer(
            marginAll: 4,
            paddingAll: 0,
            clipBehavior: Clip.hardEdge,
            child: img,
          ),
          FxSpacing.width(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FxText.bodyMedium(
                        chat.subjectName ?? 'Subject',
                        xMuted: chat.messageStatus == 'read',
                        fontWeight: chat.messageStatus == 'read' ? 600 : 700,
                        fontSize: 22,
                        color: mTheme.onSurface.withOpacity(1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(2),
                SizedBox(
                  child: FxText.bodySmall(
                    '${S.current.chatUsers}: ${chat.firstFourUsernames}',
                    xMuted: chat.messageStatus == 'read',
                    fontWeight: chat.messageStatus == 'read' ? 500 : 700,
                    color: mTheme.onSurface.withOpacity(1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FxSpacing.height(2),
                SizedBox(
                  child: FxText.bodySmall(
                    '${S.current.chatUsers}: ${chat.firstFourUsernames}',
                    fontWeight: chat.messageStatus == 'read' ? 500 : 700,
                    xMuted: chat.messageStatus == 'read',
                    color: mTheme.onSurface.withOpacity(1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.width(8),
          if (chat.messageStatus == 'read')
            FxSpacing.height(20)
          else
            FxContainer.rounded(
              paddingAll: 6,
              color: mTheme.primary,
              child: FxText.bodySmall(
                '',
                color: mTheme.onPrimary,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSystemChat(BuildContext context, Chat chat) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    return Column(
      children: [
        FxContainer(
          onTap: () => GoRouter.of(context).go('/chatroom/${chat.id}'),
          margin: FxSpacing.nTop(12),
          paddingAll: 12,
          borderRadiusAll: 12,
          bordered: chat.messageStatus != 'read',
          border: chat.type == 'system_personal'
              ? Border.all(color: mTheme.primary, width: 1.4)
              : null,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                  ),
                  FxSpacing.width(8),
                  Expanded(
                    child: FxText.bodyMedium(
                      chat.subjectName ?? 'Subject',
                      xMuted: chat.messageStatus == 'read',
                      fontWeight: chat.messageStatus == 'read' ? 800 : 900,
                      fontSize: 22,
                      color: mTheme.onSurface.withOpacity(1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FxSpacing.width(8),
                  if (chat.messageStatus == 'read')
                    FxSpacing.height(22)
                  else
                    FxContainer.rounded(
                      paddingAll: 6,
                      color: mTheme.primary,
                      child: FxText.bodySmall(
                        '',
                        color: mTheme.onPrimary,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
