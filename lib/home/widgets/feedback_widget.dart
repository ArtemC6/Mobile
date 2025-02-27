import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/themes/themes.dart';
import 'package:flutx/utils/utils.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:voccent/error_guard/cubit/error_guard_cubit.dart';
import 'package:voccent/generated/l10n.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  static const outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(style: BorderStyle.none),
  );

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: FxText.titleMedium(
              'Send feedback'.toUpperCase(),
              fontWeight: 550,
              color: mTheme.onBackground,
            ),
            content: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: mTheme.onBackground,
                      width: 0.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    autofocus: true,
                    style: FxTextStyle.bodyMedium(
                      color: mTheme.onBackground,
                    ),
                    cursorColor: mTheme.onBackground,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.transparent,
                      isDense: true,
                      // hintText: S.current.enterCode,
                      hintStyle: FxTextStyle.bodySmall(
                        color: mTheme.onBackground,
                      ),
                      errorBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      disabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      contentPadding: FxSpacing.fromLTRB(16, 16, 8, 16),
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: FxText.bodyLarge(
                  textAlign: TextAlign.left,
                  S.current.genericCancel,
                  fontWeight: 500,
                  fontSize: 14,
                  color: mTheme.error,
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  FirebaseCrashlytics.instance.recordError(
                    ShakeException(),
                    StackTrace.empty,
                    reason: _controller.text,
                  );

                  Navigator.of(context).pop();
                },
                child: FxText.bodyLarge(
                  'OK',
                  fontWeight: 500,
                  fontSize: 14,
                  color: mTheme.onBackground,
                ),
              ),
            ],
          )
        : Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Container(
              padding: FxSpacing.all(16),
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
                          child: FxText.titleMedium(
                            'Send feedback'.toUpperCase(),
                            fontWeight: 500,
                            color: mTheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 16),
                    child: Divider(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: mTheme.onBackground,
                        width: 0.5,
                      ),
                    ),
                    child: TextFormField(
                      controller: _controller,
                      style: FxTextStyle.bodyMedium(
                        color: mTheme.onBackground,
                      ),
                      cursorColor: mTheme.onBackground,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.transparent,
                        isDense: true,
                        // hintText: S.current.enterCode,
                        hintStyle: FxTextStyle.bodyLarge(
                          color: mTheme.onBackground,
                          fontWeight: 300,
                        ),
                        enabledBorder: outlineInputBorder,
                        disabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        contentPadding: FxSpacing.fromLTRB(16, 16, 8, 16),
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: FxSpacing.top(24),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FxButton.text(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: FxText.bodyLarge(
                            S.current.genericCancel,
                            fontWeight: 500,
                            color: mTheme.primary,
                          ),
                        ),
                        FxSpacing.width(8),
                        FxButton(
                          backgroundColor: mTheme.primary,
                          borderRadiusAll: 4,
                          elevation: 0,
                          onPressed: () {
                            FirebaseCrashlytics.instance.recordError(
                              ShakeException(),
                              StackTrace.empty,
                              reason: _controller.text,
                            );

                            Navigator.of(context).pop();
                          },
                          child: FxText.bodyLarge(
                            'OK',
                            fontWeight: 600,
                            color: mTheme.onPrimary,
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
