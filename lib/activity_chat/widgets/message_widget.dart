import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/activity_chat/cubit/models/messages/message.dart';
import 'package:voccent/activity_chat/widgets/dynamic_button.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.adminMessage,
    required this.theirMessage,
    required this.message,
    super.key,
  });

  final bool adminMessage;
  final bool theirMessage;

  final Message message;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onLongPressStart: (details) {
          if (theirMessage) {
            VibrationController.onPressedVibration();
            _showTheirPopupMenu(
              context,
              details.globalPosition,
              message.meta.first.body ?? '',
            );
          } else {
            VibrationController.onPressedVibration();
            _showMyPopupMenu(
              context,
              details.globalPosition,
              message.id ?? '',
              message.meta.first.id ?? '',
              message.meta.first.body ?? '',
            );
          }
        },
        child: Align(
          alignment:
              theirMessage ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: mTheme.background,
            ),
            constraints: const BoxConstraints(maxWidth: 350),
            child: FxContainer(
              width: MediaQuery.sizeOf(context).width * 0.7,
              color: adminMessage
                  ? mTheme.primary.withOpacity(0.3)
                  : theirMessage
                      ? isDarkTheme
                          ? FxAppTheme.theme.cardTheme.color
                          : mTheme.onPrimary
                      : mTheme.secondary.withOpacity(0.3),
              borderRadiusAll: 8,
              marginAll: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: theirMessage
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  for (final i in message.meta)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (adminMessage)
                          Row(
                            children: [
                              Expanded(
                                child: FxText.bodyMedium(
                                  '${message.username}',
                                  color: mTheme.primary,
                                  fontWeight: 700,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.grade,
                                color: mTheme.secondary,
                                size: 14,
                              ),
                            ],
                          )
                        else if (theirMessage)
                          FxText.bodyMedium(
                            (message.username == 'system')
                                ? S.current.navItemLens
                                : '${message.username}',
                            color: mTheme.primary,
                            fontWeight: 700,
                          )
                        else
                          Container(),
                        FxSpacing.height(8),
                        DynamicButton(
                          text: i.body ?? '',
                        ),
                        FxSpacing.height(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FxText.bodySmall(
                              Intl().date().format(
                                    DateTime.parse(
                                      i.updatedAt ?? message.createdat!,
                                    ).toLocal(),
                                  ),
                              color: mTheme.onSurface.withOpacity(0.5),
                            ),
                            if (i.updatedAt != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  FeatherIcons.edit3,
                                  size: 15,
                                  color: mTheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyPopupMenu(
    BuildContext context,
    Offset tapPosition,
    String messageId,
    String metaId,
    String messageBody,
  ) async {
    final mTheme = Theme.of(context).colorScheme;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final screenWidth = overlay.size.width;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - tapPosition.dx - 16,
        tapPosition.dy,
        16,
        overlay.size.height - tapPosition.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: mTheme.background,
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FxText.bodyLarge(
                S.current.genericCopy,
                color: mTheme.onSurface.withOpacity(1),
              ),
              Icon(
                FeatherIcons.copy,
                size: 20,
                color: mTheme.onSurface.withOpacity(1),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FxText.bodyLarge(
                S.current.genericEdit,
                color: mTheme.onSurface.withOpacity(1),
              ),
              Icon(
                FeatherIcons.edit3,
                size: 20,
                color: mTheme.onSurface.withOpacity(1),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FxText.bodyLarge(
                S.current.genericDelete,
                color: mTheme.onSurface.withOpacity(1),
              ),
              Icon(
                FeatherIcons.trash2,
                size: 20,
                color: mTheme.onSurface.withOpacity(1),
              ),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'copy') {
        await Clipboard.setData(ClipboardData(text: messageBody));
      } else if (value == 'edit') {
        context.read<ActivityChatCubit>().startEditingMessage(
              initialText: messageBody,
              metaId: metaId,
              messageId: messageId,
            );
      } else if (value == 'delete') {
        await context.read<ActivityChatCubit>().deleteMessageText(messageId);
      }
    });
  }

  Future<void> _showTheirPopupMenu(
    BuildContext context,
    Offset tapPosition,
    String messageBody,
  ) async {
    final mTheme = Theme.of(context).colorScheme;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        16,
        tapPosition.dy,
        overlay.size.width - tapPosition.dx,
        overlay.size.height - tapPosition.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: mTheme.background,
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FxText.bodyLarge(
                S.current.genericCopy,
                color: mTheme.onSurface.withOpacity(1),
              ),
              Icon(
                FeatherIcons.copy,
                size: 20,
                color: mTheme.onSurface.withOpacity(1),
              ),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'copy') {
        await Clipboard.setData(ClipboardData(text: messageBody));
      }
    });
  }
}
