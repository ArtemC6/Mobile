import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/guide/view/categories_translate.dart';
import 'package:voccent/widgets/loading_animation_widget.dart';

class AIIsTypingWidget extends StatelessWidget {
  const AIIsTypingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: mTheme.background,
          ),
          constraints: const BoxConstraints(maxWidth: 350),
          child: FxContainer(
            width: MediaQuery.sizeOf(context).width * 0.7,
            color: isDarkTheme
                ? FxAppTheme.theme.cardTheme.color
                : mTheme.onPrimary,
            borderRadiusAll: 8,
            marginAll: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  S.current.navItemLens,
                  color: mTheme.primary,
                  fontWeight: 700,
                ),
                FxSpacing.height(8),
                LoadingAnimationWidget(
                  emojis: true,
                  color: mTheme.onSurface.withOpacity(1),
                  loadingText: FxText.bodyMedium(
                    S.current.genericThinking.toCapitalized(),
                    color: mTheme.onSurface.withOpacity(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
