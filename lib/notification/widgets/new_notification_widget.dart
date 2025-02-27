import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/notification/cubit/models/notification/notification.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class NewNotificationWidget extends StatelessWidget {
  const NewNotificationWidget({
    required this.thisContext,
    this.newNotification,
    super.key,
  });
  final NewNotification? newNotification;
  final BuildContext thisContext;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final cache = context.read<ServerAddress>().cacheImgHash();
    final imagePath =
        '/api/v1/asset/object/classroom_picture/${newNotification?.objectId}?time=$cache';
    final bannerPath =
        '/api/v1/asset/object/classroom_banner/${newNotification?.objectId}?time=$cache';

    return FxContainer(
      onTap: () {
        if (newNotification?.objectType == 'classroom') {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          VibrationController.onPressedVibration();
          GoRouter.of(thisContext).push(
            '/activity_chat',
            extra: ActivityChatData(
              operationId: 'classroom_${newNotification?.objectId ?? ''}',
              title: newNotification?.objectName ?? '',
              imagePath: imagePath,
              bannerPath: bannerPath,
            ),
          );
        }
      },
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: FxContainer(
          paddingAll: 0,
          marginAll: 0,
          bordered: true,
          borderColor: mTheme.primary,
          borderRadiusAll: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              '$apiBaseUrl/api/v1/asset/object/user_avatar/${newNotification?.userId ?? ''}',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/Ccwhitebg.png',
                fit: BoxFit.cover,
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            FxText.titleMedium(
              newNotification?.userName ?? '',
              color: mTheme.primary,
            ),
            const Expanded(child: SizedBox()),
            FxText.bodySmall(
              'now',
              color: Colors.black,
            ),
          ],
        ),
        subtitle: FxText.titleMedium(
          newNotification?.message ?? '',
          color: Colors.black,
          maxLines: 2,
        ),
      ),
    );
  }
}
