import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voccent/generated/l10n.dart';

class QrScannerController extends StatefulWidget {
  const QrScannerController({
    required this.barcodeCapture,
    super.key,
  });

  final void Function(BarcodeCapture) barcodeCapture;

  @override
  State<QrScannerController> createState() => _QrScannerControllerState();
}

class _QrScannerControllerState extends State<QrScannerController>
    with WidgetsBindingObserver {
  late final MobileScannerController controller;
  StreamSubscription<BarcodeCapture>? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(widget.barcodeCapture);
        unawaited(controller.start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController();
    _subscription = controller.barcodes.listen(widget.barcodeCapture);
    unawaited(controller.start());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _subscription = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: FxText.titleMedium(
          S.current.qrCodeScanner.toUpperCase(),
          fontWeight: 700,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      body: MobileScanner(
        controller: controller,
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.white,
              icon: Icon(
                controller.torchEnabled
                    ? Icons.flashlight_on_outlined
                    : Icons.flashlight_off_outlined,
                color:
                    controller.torchEnabled ? mTheme.secondary : mTheme.primary,
              ),
              iconSize: 30,
              onPressed: controller.toggleTorch,
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(
                controller.facing == CameraFacing.front
                    ? Icons.flip_camera_ios_outlined
                    : Icons.flip_camera_ios_rounded,
                color: controller.facing == CameraFacing.front
                    ? mTheme.secondary
                    : mTheme.primary,
              ),
              iconSize: 30,
              onPressed: controller.switchCamera,
            ),
          ],
        ),
      ),
    );
  }
}
