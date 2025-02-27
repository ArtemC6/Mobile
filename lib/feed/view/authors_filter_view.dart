import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';

class AuthorsFilterView extends StatelessWidget {
  const AuthorsFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (previous, current) => previous.author != current.author,
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;
        final theme = context.watch<ThemeCubit>().state.theme;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                FeatherIcons.chevronLeft,
                size: 25,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            elevation: 0,
            title: FxText.bodyLarge(
              S.current.filterByAuthor,
              fontWeight: 700,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  FxSpacing.height(8),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        hintText: S.current.filterAuthorsName,
                        hintStyle: FxTextStyle.titleMedium(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: mTheme.surface,
                      ),
                      initialValue: state.author,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) =>
                          context.read<FeedCubit>().setAuthorFilter(
                                value.trim(),
                              ),
                    ),
                  ),
                  FxSpacing.height(20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: FxSpacing.x(60),
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      elevation: 0,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        FeatherIcons.check,
                        color: mTheme.onPrimary,
                      ),
                      label: FxText.bodyLarge(
                        S.current.filterApply,
                        fontWeight: 700,
                        color: mTheme.onPrimary,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      backgroundColor: mTheme.primary,
                    ),
                  ),
                  FxSpacing.height(60),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
