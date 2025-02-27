import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/story/cubit/models/story_pass_character.dart';
import 'package:voccent/story/cubit/story_cubit.dart';

class SelectRoleTile extends StatefulWidget {
  const SelectRoleTile({
    required this.index,
    super.key,
  });

  final int index;

  @override
  State<SelectRoleTile> createState() => _BuildSelectRoleTileState();
}

class _BuildSelectRoleTileState extends State<SelectRoleTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final apiBaseUrl = context.read<ServerAddress>().httpUri;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final character =
            state.storyPassCharacters.values.elementAt(widget.index);

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _onClick(
                context.read<HomeCubit>().state.user.username!,
                character,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: mTheme.primary, width: 1.4),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FxText.bodyMedium(
                          character.characterName ?? '',
                          color:
                              isDarkTheme ? mTheme.onPrimary : mTheme.primary,
                          fontWeight: 800,
                          maxLines: 1,
                        ),
                      ),
                      FxSpacing.width(8),
                      Row(
                        children: [
                          if (character.userId != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 42,
                                width: 42,
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    SizedBox(
                                      height: 38,
                                      width: 38,
                                      child: Image.network(
                                        '$apiBaseUrl/api/v1/asset/object/user_avatar/${character.userId}',
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    AnimatedPositioned(
                                      width: 13,
                                      height: 13,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: state.isOnlineUser[
                                                      character.userId] ??
                                                  false
                                              ? mTheme.tertiary
                                              : mTheme.onBackground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          FxSpacing.width(8),
                          FxText.bodyMedium(
                            character.userId != null ? character.userName! : '',
                            color: character.userName ==
                                    context
                                        .read<HomeCubit>()
                                        .state
                                        .user
                                        .username!
                                ? mTheme.secondary
                                : mTheme.onBackground.withAlpha(170),
                            maxLines: 1,
                            fontWeight: 600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: isLoading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          character.userCheck
                              ? FeatherIcons.checkSquare
                              : FeatherIcons.square,
                          color: character.userCheck
                              ? (character.userName ==
                                      context
                                          .read<HomeCubit>()
                                          .state
                                          .user
                                          .username!
                                  ? mTheme.secondary
                                  : mTheme.onBackground.withAlpha(170))
                              : (isDarkTheme
                                  ? mTheme.onPrimary
                                  : mTheme.primary),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onClick(String loggedInUsername, StoryPassCharacter character) {
    if (character.userCheck) {
      if (character.userName != loggedInUsername) {
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    HapticFeedback.lightImpact();
    context.read<StoryCubit>().changeUserRole(
          character.characterId!,
        );
  }
}
