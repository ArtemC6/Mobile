import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/activity_chat/activity_chat_data.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/activity_chat/widgets/activity_chat_screen.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/web_socket/web_socket.dart';

class ActivityChatView extends StatelessWidget {
  const ActivityChatView({required this.activityChatData, super.key});
  final ActivityChatData? activityChatData;

  @override
  Widget build(BuildContext context) {
    final operationId = activityChatData?.operationId;
    final title = activityChatData?.title;
    final imagePath = activityChatData?.imagePath;
    final bannerPath = activityChatData?.bannerPath;
    final adminId = activityChatData?.adminId;
    final isVoccentAI = activityChatData?.isVoccentAI;
    final isLocalPath = activityChatData?.isLocalPath;

    return BlocProvider(
      create: (context) => ActivityChatCubit(
        context.read<WebSocket>(),
        context.read<AuthCubit>().state.userToken,
      )..init(operationId: operationId, isVoccentAI: isVoccentAI),
      child: ActivityChatScreen(
        title: title,
        imagePath: imagePath ?? '',
        bannerPath: bannerPath ?? '',
        adminId: adminId ?? '',
        isLocalPath: isLocalPath ?? false,
      ),
    );
  }
}
