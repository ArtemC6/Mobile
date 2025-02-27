// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/themes/themes.dart';
import 'package:flutx/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/debounce.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/widgets/qr_scanner_controller.dart';
import 'package:voccent/widgets/shake_animated_text.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  static const outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(style: BorderStyle.none),
  );
  bool isProcessingBarcode = false;
  Future<void> _handleBarcode(BarcodeCapture barcodeCapture) async {
    if (isProcessingBarcode) return;
    isProcessingBarcode = true;

    try {
      await context.read<ClassroomCardCubit>().foundBarcode(barcodeCapture);
      final id = await context.read<ClassroomCardCubit>().joinClassroomByCode(
            context.read<HomeCubit>().state.user,
          );
      if (mounted) {
        context.read<ClassroomCardCubit>().setRecentClassroom(id);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await GoRouter.of(context).push('/classroom_card/$id');
      }
    } finally {
      isProcessingBarcode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: (context, state) {
        final isCodeValid = state.isCodeValid;
        if (!isCodeValid) {
          VibrationController.errorVibration();
        }
        return AlertDialog.adaptive(
          title: Text(
            S.current.classroomJoinCr.toUpperCase(),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!state.isLoadingJoinCode)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: mTheme.onBackground,
                        width: 0.5,
                      ),
                    ),
                    child: TextFormField(
                      style: FxTextStyle.bodyMedium(
                        color: mTheme.onBackground,
                      ),
                      cursorColor: mTheme.onBackground,
                      showCursor: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.transparent,
                        isDense: true,
                        hintText: S.current.enterCode,
                        hintStyle: FxTextStyle.bodyMedium(
                          color: mTheme.onBackground,
                        ),
                        errorBorder: outlineInputBorder,
                        enabledBorder: outlineInputBorder,
                        disabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        contentPadding: FxSpacing.fromLTRB(16, 16, 8, 16),
                        isCollapsed: true,
                        suffixIcon: Material(
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context).push<String>(
                                MaterialPageRoute(
                                  builder: (context) => QrScannerController(
                                    barcodeCapture: _handleBarcode,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            splashColor: mTheme.onBackground.withOpacity(0.5),
                            child: Icon(
                              Icons.qr_code_scanner,
                              color: mTheme.onBackground,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final c = context.read<ClassroomCardCubit>();
                        Debounce().run(() {
                          c.fillEnterCode(value);
                        });
                      },
                    ),
                  )
                else
                  const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!isCodeValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ShakeAnimatedText(
                              S.current.tryAnotherCode,
                              textStyle: FxTextStyle.bodySmall(
                                color: mTheme.error,
                              ),
                            ),
                          ],
                          pause: Duration.zero,
                        ),
                      ),
                    ),
                  )
                else
                  Container(height: 17),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                S.current.genericCancel,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (!state.isLoadingJoinCode)
              TextButton(
                onPressed: () async {
                  if (state.enterCode.isNotEmpty) {
                    final c = context.read<ClassroomCardCubit>();
                    final id = await context
                        .read<ClassroomCardCubit>()
                        .joinClassroomByCode(
                          context.read<HomeCubit>().state.user,
                        );
                    if (mounted) {
                      c.setRecentClassroom(id);
                      Navigator.of(context).pop();
                      await GoRouter.of(context).push('/classroom_card/$id');
                    }
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        );
      },
    );
  }
}
