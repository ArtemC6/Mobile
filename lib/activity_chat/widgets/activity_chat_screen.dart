import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/activity_chat/cubit/activity_chat_cubit.dart';
import 'package:voccent/activity_chat/widgets/chat_info_drawer.dart';
import 'package:voccent/activity_chat/widgets/chat_text_field.dart';
import 'package:voccent/activity_chat/widgets/messages_widget.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/root/root_widget.dart';

class ActivityChatScreen extends StatelessWidget {
  const ActivityChatScreen({
    required this.title,
    required this.imagePath,
    required this.bannerPath,
    required this.isLocalPath,
    this.adminId = '',
    super.key,
  });

  final String? title;
  final String imagePath;
  final String bannerPath;
  final String adminId;
  final bool isLocalPath;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    return BlocBuilder<ActivityChatCubit, ActivityChatState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      child: Image.network(
                        '$apiBaseUrl$bannerPath',
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(.1),
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: mTheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      size: 25,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                  centerTitle: true,
                  title: Column(
                    children: [
                      FxText.titleMedium(
                        title ?? '',
                        fontWeight: 700,
                        textScaleFactor: 1.2257,
                        color: mTheme.onSurface.withOpacity(1),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      if (!state.isVoccentAI && state.status == Status.ready)
                        FxText.bodySmall(
                          '${state.usersOnline.length} '
                          '${S.current.genericOnline}',
                          color: mTheme.onSurface.withOpacity(1),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                  actions: [
                    FxContainer(
                      color: Colors.transparent,
                      paddingAll: 0,
                      onTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: !isLocalPath
                                ? Image.network(
                                    '$apiBaseUrl$imagePath',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/Ccwhitebg.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/Ccwhitebg.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                endDrawer: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    color: isDarkTheme
                        ? FxAppTheme.theme.cardTheme.color
                        : mTheme.onPrimary.withOpacity(0.75),
                    child: ChatInfoDrawer(
                      title: title,
                      imagePath: imagePath,
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    MessagesWidget(adminId),
                    const ChatTextField(),
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
