import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutx/flutx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/widgets/select_role_tile.dart';
import 'package:voccent/story/widgets/start_story_button.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class NewStoryView extends StatefulWidget {
  const NewStoryView({super.key});

  @override
  State<NewStoryView> createState() => _NewStoryViewState();
}

class _NewStoryViewState extends State<NewStoryView> {
  bool starting = false;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDark = mTheme.brightness == Brightness.dark;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        if (context.read<AuthCubit>().state.isFirstRun) {
          return const SizedBox();
        }

        final description = state.story?.description ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    FxContainer(
                      color: isDark ? Colors.black : Colors.white,
                      child: FxText.titleLarge(
                        state.story?.name ?? '',
                        fontWeight: 700,
                        textScaleFactor: 1.2257,
                        color: isDark ? Colors.white : Colors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FxSpacing.height(8),
                    if (description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FxContainer(
                          color: isDark ? Colors.black : Colors.white,
                          child: Linkify(
                            text: description,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            linkStyle: TextStyle(
                              color: mTheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            onOpen: (link) =>
                                context.read<StoryCubit>().openLink(link.url),
                            options: const LinkifyOptions(humanize: false),
                            linkifiers: const <Linkifier>[
                              UrlLinkifier(),
                            ],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    FxContainer(
                      color: isDark ? Colors.black : Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FxText.bodyMedium(
                                  S.current.storyChooseCharacters,
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: 700,
                                ),
                                if (state.storyPass.status == 'new')
                                  IconButton(
                                    onPressed: () =>
                                        _showInvitationSheet(context),
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.person_add,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    color: mTheme.onBackground,
                                  ),
                              ],
                            ),
                          ),
                          FxSpacing.height(8),
                          Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    state.storyPassCharacters.values.length,
                                itemBuilder: (context, index) {
                                  return SelectRoleTile(
                                    index: index,
                                    key: UniqueKey(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (starting)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              else if (!starting &&
                  state.story!.createdby ==
                      context.read<HomeCubit>().state.user.id)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StartButton(
                    textButton: S.current.storyStart,
                    onTap: () {
                      VibrationController.onPressedVibration();
                      context.read<StoryCubit>().startStory();

                      setState(() {
                        starting = true;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showInvitationSheet(BuildContext context) {
    final cubit = context.read<StoryCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final mTheme = Theme.of(context).colorScheme;
        final textEditingController = TextEditingController();

        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<StoryCubit, StoryState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: mTheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: DraggableScrollableSheet(
                  expand: false,
                  builder: (_, controller) => SingleChildScrollView(
                    controller: controller,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          FxSpacing.height(16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: FxButton.block(
                              backgroundColor: mTheme.primary,
                              borderRadiusAll: 8,
                              elevation: 0,
                              onPressed: () {
                                final apiBaseUrl =
                                    context.read<ServerAddress>().httpUri;
                                final size = MediaQuery.of(context).size;
                                Share.share(
                                  '$apiBaseUrl/story-pass/'
                                  '${cubit.state.storyPass.id}?'
                                  'l=${cubit.state.storyPass.link}',
                                  sharePositionOrigin: Rect.fromLTWH(
                                    0,
                                    0,
                                    size.width,
                                    size.height / 2,
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FeatherIcons.share2),
                                  FxSpacing.width(8),
                                  FxText.bodyLarge(
                                    S.current.storyShareLink,
                                    color: mTheme.onPrimary,
                                    fontWeight: 700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FxSpacing.height(16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FxText.bodyLarge(
                                S.current.storyInvite,
                                color: mTheme.onBackground,
                                fontWeight: 700,
                              ),
                            ),
                          ),
                          FxSpacing.height(8),
                          Row(
                            children: [
                              Expanded(
                                child: FxContainer(
                                  margin: FxSpacing.x(8),
                                  padding: FxSpacing.y(6),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  borderRadiusAll: 8,
                                  child: Row(
                                    children: [
                                      FxSpacing.width(8),
                                      Expanded(
                                        child: TextField(
                                          controller: textEditingController,
                                          autofocus: true,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          cursorColor:
                                              mTheme.onPrimaryContainer,
                                          decoration: InputDecoration(
                                            hintStyle: FxTextStyle.bodyMedium(),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.only(left: 8),
                                          ),
                                        ),
                                      ),
                                      FxContainer(
                                        padding: EdgeInsets.zero,
                                        color: mTheme.primary,
                                        child: IconButton(
                                          onPressed: () {
                                            if (textEditingController
                                                .text.isEmpty) {
                                              return;
                                            }
                                            cubit.sendInvite(
                                              textEditingController.text,
                                            );
                                            textEditingController.clear();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          icon: Icon(
                                            Icons.person_add,
                                            size: 20,
                                            color: mTheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                      FxSpacing.width(8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FxSpacing.height(16),
                          if (state.invitedUsers.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.invitedUsers.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              FeatherIcons.send,
                                              color: mTheme.primary,
                                            ),
                                            FxSpacing.width(16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FxText.bodyLarge(
                                                    state.invitedUsers[index],
                                                    fontWeight: 600,
                                                    color: mTheme.onBackground,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: mTheme.primary,
                                        thickness: 0.2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
