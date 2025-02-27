import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/sound_receiver_mode/cubit/sound_receirver_mode_cubit.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/widgets/vibration_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SoundReceirverModeWidget extends StatefulWidget {
  const SoundReceirverModeWidget({super.key});
  static const outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(style: BorderStyle.none),
  );

  @override
  State<SoundReceirverModeWidget> createState() =>
      _SoundReceirverModeWidgetState();
}

class _SoundReceirverModeWidgetState extends State<SoundReceirverModeWidget> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final hours = _seconds ~/ 3600;
    final minutes = (_seconds % 3600) ~/ 60;
    final seconds = _seconds % 60;

    return BlocProvider(
      create: (_) => SoundReceiverModeCubit(
        context.read<UserScopeClient>(),
        context.read<WebSocket>(),
        context.read<AuthCubit>().state.userToken,
        context.read<SharedPreferences>(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              FeatherIcons.chevronLeft,
              size: 25,
              color: mTheme.onBackground,
            ),
          ),
          centerTitle: true,
          title: FxText.titleMedium(
            'Streamotion Probe'.toUpperCase(),
            fontWeight: 700,
            textScaleFactor: 1.46,
            color: mTheme.secondary,
          ),
        ),
        body: BlocConsumer<SoundReceiverModeCubit, SoundReceiverModeState>(
          listener: (context, state) {
            if (state.isModeActive && _timer == null) {
              _startTimer();
            } else if (!state.isModeActive && _timer != null) {
              setState(() {
                _seconds = 0;
              });
              _timer?.cancel();
              _timer = null;
            }
          },
          builder: (context, state) {
            return BlocBuilder<SoundReceiverModeCubit, SoundReceiverModeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2, left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FxContainer(
                          onTap: () {
                            VibrationController.onPressedVibration();
                            state.isModeActive
                                ? _showDeactivateDialog(context, mTheme)
                                : _showActivateDialog(context, mTheme);
                          },
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.85,
                          bordered: true,
                          borderColor: mTheme.secondary,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                state.isModeActive
                                    ? Icons.power_settings_new
                                    : Icons.power_settings_new,
                                size: 225,
                                color: state.isModeActive
                                    ? mTheme.secondary
                                    : mTheme.primary,
                              ),
                              FxText.displaySmall(
                                state.isModeActive
                                    ? 'activated'.toUpperCase()
                                    : 'is not activated'.toUpperCase(),
                                textAlign: TextAlign.center,
                                color: mTheme.secondary,
                              ),
                              Expanded(
                                child: Center(
                                  child: state.isModeActive
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: FxContainer(
                                                color: Colors.black,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: FxText.displayMedium(
                                                    hours
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    textAlign: TextAlign.center,
                                                    color: mTheme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: FxContainer(
                                                color: Colors.black,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: FxText.displayMedium(
                                                    minutes
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    textAlign: TextAlign.center,
                                                    color: mTheme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: FxContainer(
                                                color: Colors.black,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: FxText.displayMedium(
                                                    seconds
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    textAlign: TextAlign.center,
                                                    color: mTheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Widget?> _showActivateDialog(
    BuildContext context,
    ColorScheme mTheme,
  ) {
    final textEditingController = TextEditingController();
    return showAdaptiveDialog<Widget>(
      context: context,
      builder: (_) {
        return AlertDialog.adaptive(
          title: FxText.bodyLarge(
            'Do you have a code?'.toUpperCase(),
            color: mTheme.primary,
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    controller: textEditingController,
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
                      errorBorder: SoundReceirverModeWidget.outlineInputBorder,
                      enabledBorder:
                          SoundReceirverModeWidget.outlineInputBorder,
                      disabledBorder:
                          SoundReceirverModeWidget.outlineInputBorder,
                      focusedBorder:
                          SoundReceirverModeWidget.outlineInputBorder,
                      border: SoundReceirverModeWidget.outlineInputBorder,
                      contentPadding: FxSpacing.all(16),
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                VibrationController.onPressedVibration();
                Navigator.of(context).pop();
              },
              child: FxText.bodyLarge(
                S.current.cancel.toUpperCase(),
                color: mTheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {
                VibrationController.onPressedVibration();
                context
                    .read<SoundReceiverModeCubit>()
                    .activate(textEditingController.text);
                Navigator.of(context).pop();
              },
              child: FxText.bodyLarge(
                'OK',
                color: mTheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Widget?> _showDeactivateDialog(
    BuildContext context,
    ColorScheme mTheme,
  ) {
    return showAdaptiveDialog<Widget>(
      context: context,
      builder: (_) {
        return AlertDialog.adaptive(
          title: FxText.bodyLarge(
            'do you want to deactivate the mode?'.toUpperCase(),
            color: mTheme.primary,
            textAlign: TextAlign.center,
          ),
          content: const SizedBox(height: 30),
          actions: [
            TextButton(
              onPressed: () {
                VibrationController.onPressedVibration();
                Navigator.of(context).pop();
              },
              child: FxText.bodyLarge(
                S.current.cancel.toUpperCase(),
                color: mTheme.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {
                VibrationController.onPressedVibration();
                context.read<SoundReceiverModeCubit>().deactivate();
                Navigator.of(context).pop();
              },
              child: FxText.bodyLarge(
                'OK',
                color: mTheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}
