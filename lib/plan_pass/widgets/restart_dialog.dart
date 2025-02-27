import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';

class RestartIosDialog extends StatelessWidget {
  const RestartIosDialog({
    required this.onStartAgainPressed,
    required this.planName,
    super.key,
  });

  final void Function() onStartAgainPressed;

  final String planName;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FxText.titleMedium(
          planName,
          fontWeight: 700,
          color: mTheme.onSurface.withOpacity(1),
        ),
      ),
      content: FxText.titleSmall(
        S.current.restartPlan,
        color: mTheme.onSurface.withOpacity(1),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: FxText.titleMedium(
            S.current.genericCancel,
            color: mTheme.onSurface.withOpacity(1),
          ),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onStartAgainPressed,
          child: FxText.titleMedium(
            S.current.genericStartAgain,
            color: mTheme.secondary,
          ),
        ),
      ],
    );
  }
}

class RestartAndroidDialog extends StatelessWidget {
  const RestartAndroidDialog({
    required this.onStartAgainPressed,
    required this.planName,
    super.key,
  });

  final void Function() onStartAgainPressed;

  final String planName;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: FxSpacing.all(20),
        decoration: BoxDecoration(
          color: mTheme.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: FxText.titleLarge(
                      planName,
                      fontWeight: 600,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              margin: FxSpacing.only(top: 8),
              child: FxText.titleSmall(
                S.current.restartPlan,
                color: mTheme.onSurface.withOpacity(1),
              ),
            ),
            Container(
              margin: FxSpacing.top(24),
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FxButton(
                    backgroundColor: mTheme.primary,
                    borderRadiusAll: 4,
                    elevation: 0,
                    onPressed: () => Navigator.pop(context),
                    child: FxText.bodyMedium(
                      S.current.genericCancel,
                      fontWeight: 600,
                      color: mTheme.onPrimary,
                    ),
                  ),
                  FxButton.text(
                    onPressed: onStartAgainPressed,
                    child: FxText.bodyMedium(
                      S.current.genericStartAgain,
                      fontWeight: 600,
                      color: mTheme.onSurface.withOpacity(1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
