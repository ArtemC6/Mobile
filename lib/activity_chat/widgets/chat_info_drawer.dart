import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class ChatInfoDrawer extends StatelessWidget {
  const ChatInfoDrawer({
    required this.imagePath,
    required this.title,
    super.key,
  });
  final String? title;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;

    return BlocBuilder<ActivityChatCubit, ActivityChatState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: isDarkTheme
              ? FxAppTheme.theme.cardTheme.color
              : mTheme.background,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '$apiBaseUrl$imagePath',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/Ccwhitebg.png',
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    FxSpacing.width(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.titleLarge(
                            title ?? '',
                            color: mTheme.onSurface.withOpacity(1),
                          ),
                          FxSpacing.height(8),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: mTheme.onSurface.withOpacity(0.1),
                ),
                FxSpacing.height(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxContainer(
                      color: mTheme.onBackground.withOpacity(0.1),
                      onTap: () {
                        VibrationController.onPressedVibration();
                        context
                            .read<ActivityChatCubit>()
                            .changeNotificationSettings(MuteType.author);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: FxText.bodyLarge(
                                S.current.authorNotifications,
                                color: mTheme.onSurface.withOpacity(1),
                              ),
                            ),
                            Icon(
                              state.muteAuthor
                                  ? Icons.notifications_off
                                  : Icons.notifications,
                              color: mTheme.onSurface.withOpacity(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FxSpacing.height(8),
                    FxContainer(
                      color: mTheme.onBackground.withOpacity(0.1),
                      onTap: () {
                        VibrationController.onPressedVibration();
                        context
                            .read<ActivityChatCubit>()
                            .changeNotificationSettings(MuteType.user);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: FxText.bodyLarge(
                                S.current.usersNotifications,
                                color: mTheme.onSurface.withOpacity(1),
                              ),
                            ),
                            Icon(
                              state.muteUser
                                  ? Icons.notifications_off
                                  : Icons.notifications,
                              color: mTheme.onSurface.withOpacity(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Divider(
                  color: mTheme.onSurface.withOpacity(0.1),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.usersOnline.length,
                    itemBuilder: (context, index) {
                      final item = state.usersOnline[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: FxContainer(
                          paddingAll: 0,
                          marginAll: 0,
                          bordered: true,
                          borderColor: mTheme.primary,
                          borderRadiusAll: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '$apiBaseUrl/api/v1/asset/object/user_avatar/${item.id}',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/Ccwhitebg.png',
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                        title: FxText.bodyLarge(
                          '${item.username}',
                          color: mTheme.onSurface.withOpacity(1),
                        ),
                        subtitle: FxText.bodyMedium(
                          S.current.genericOnline,
                          color: mTheme.tertiary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
