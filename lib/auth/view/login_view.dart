import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/auth/cubit/user_status.dart';
import 'package:voccent/auth/widgets/loading_widget.dart';
import 'package:voccent/auth/widgets/login_button_widget.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/theme/app_theme.dart';
import 'package:voccent/theme/cubit/theme_cubit.dart';
import 'package:voccent/theme/theme_type.dart';
import 'package:voccent/widgets/qr_scanner_controller.dart';
import 'package:voccent/widgets/web_view_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final Timer timer;
  String image = 'assets/images/onboarding/katya.png';
  bool isProcessingBarcode = false;

  @override
  void initState() {
    super.initState();
    context.read<ThemeCubit>().updateTheme(ThemeType.dark);
    timer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() => image = _randomImage());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _randomImage() {
    final images = [
      'assets/images/onboarding/modou.png',
      'assets/images/onboarding/sadhana.png',
      'assets/images/onboarding/katya.png',
    ];

    final max = images.length;
    final random = Random();
    int index;

    do {
      index = random.nextInt(max);
    } while (images[index] == image);

    return images[index];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    bool containsVoccent(String url) => url.contains('app.voccent.com');
    Future<void> handleBarcode(BarcodeCapture barcodeCapture) async {
      if (isProcessingBarcode) return;
      isProcessingBarcode = true;

      final barcodes = barcodeCapture.barcodes;
      if (barcodes.isEmpty) {
        isProcessingBarcode = false;
        return;
      }

      final barcode = barcodes.first;
      final rawValue = barcode.rawValue ?? '';
      if (!containsVoccent(rawValue)) {
        isProcessingBarcode = false;
        return;
      }

      final state = context.read<AuthCubit>();
      if (state.state.qrCode.isEmpty) {
        final code = rawValue.split('/').last;
        Navigator.pop(context);
        await state.saveQrCode(code);
        isProcessingBarcode = false;
      }
    }

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.userStatus == UserStatus.submissionFailed,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Authentication Failure'),
          ),
        ),
      builder: (context, state) {
        return BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.userStatus != UserStatus.missingUsername &&
              current.userStatus == UserStatus.missingUsername,
          listener: (context, state) =>
              GoRouter.of(context).push('/onboarding'),
          builder: (context, state) {
            if (state.userStatus == UserStatus.authenticating ||
                state.userStatus == UserStatus.authenticated ||
                state.userStatus == UserStatus.missingUsername ||
                state.userStatus == UserStatus.checkingUsername ||
                state.userStatus == UserStatus.usernameIsTaken) {
              return const LoadingWidget();
            }

            final theme = AppTheme.lightTheme;
            final mTheme = theme.colorScheme;

            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _ImageGrainsWidget(
                        image: image,
                        size: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.55,
                        ),
                      ),
                    ),
                    FxSpacing.height(16),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 22),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (state.qrCode.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Center(
                                    child: DelayedDisplay(
                                      delay: const Duration(milliseconds: 400),
                                      child: FxText.bodyMedium(
                                        S.current
                                            .pleaseSelectAuthorizationMethod,
                                        color: mTheme.onPrimary,
                                        fontWeight: 700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              if (Platform.isIOS)
                                DelayedDisplay(
                                  child: LoginButtonWidget(
                                    onPressed: () => context
                                        .read<AuthCubit>()
                                        .logInWithApple(),
                                    text: 'Apple',
                                    image: SvgPicture.asset(
                                      'assets/svg/apple_logo_black.svg',
                                      height: height / 11,
                                    ),
                                  ),
                                )
                              else
                                FxSpacing.height(28),
                              DelayedDisplay(
                                child: LoginButtonWidget(
                                  onPressed: () => context
                                      .read<AuthCubit>()
                                      .logInWithGoogle(),
                                  text: 'Google',
                                  image: SvgPicture.asset(
                                    'assets/svg/google.svg',
                                    height: height / 12,
                                  ),
                                ),
                              ),
                              DelayedDisplay(
                                child: LoginButtonWidget(
                                  onPressed: () => context
                                      .read<AuthCubit>()
                                      .logInWithMicrosoft(),
                                  text: 'Microsoft',
                                  image: Image(
                                    image: const AssetImage(
                                      'assets/svg/microsoft.png',
                                    ),
                                    height: height / 12,
                                  ),
                                ),
                              ),
                              if (state.qrCode.isEmpty)
                                DelayedDisplay(
                                  child: LoginButtonWidget(
                                    onPressed: () async {
                                      await Navigator.of(context).push<String>(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              QrScannerController(
                                            barcodeCapture: handleBarcode,
                                          ),
                                        ),
                                      );
                                    },
                                    text: S.current.scanQRCode,
                                    image: const Icon(
                                      Icons.qr_code_scanner,
                                      size: 38,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SafeArea(
                          top: false,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.all(width / 62),
                              child: Column(
                                children: [
                                  FxSpacing.height(22),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () =>
                                            Navigator.of(context).push<void>(
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const WebViewWidget(
                                              'https://www.voccent.com/terms-of-use.html',
                                            ),
                                          ),
                                        ),
                                        child: DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 200),
                                          child: FxText.bodyMedium(
                                            S.current.genericTermsAndConditions,
                                            color: mTheme.onPrimary,
                                            fontWeight: 700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FxSpacing.height(4),
                                  Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () =>
                                            Navigator.of(context).push<void>(
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const WebViewWidget(
                                              'https://www.voccent.com/privacy-policy.html',
                                            ),
                                          ),
                                        ),
                                        child: DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 220),
                                          child: FxText.bodyMedium(
                                            S.current.genericPrivacyPolicy,
                                            color: mTheme.onPrimary,
                                            fontWeight: 700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TwinklingDotsPainter extends CustomPainter {
  TwinklingDotsPainter({
    required this.points,
    this.opacity = 1.0,
    this.minSize = 1.0,
    this.maxSize = 2.0,
  });

  final List<Offset> points;
  final double opacity;
  final double minSize;
  final double maxSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);

    for (final point in points) {
      final size = Random().nextDouble() * (maxSize - minSize) + minSize;
      canvas.drawCircle(point, size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ImageGrainsWidget extends StatefulWidget {
  const _ImageGrainsWidget({required this.image, required this.size});

  final String image;
  final Size size;

  @override
  _ImageGrains createState() => _ImageGrains();
}

class _ImageGrains extends State<_ImageGrainsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Offset> _points = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(
        () => setState(
          () => _points = generateRandomPoints(
            2600,
            widget.size,
          ),
        ),
      );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Offset> generateRandomPoints(int count, Size size) {
    final random = Random();
    final points = <Offset>[];

    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(
          fit: BoxFit.fitHeight,
          image: AssetImage(widget.image),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: TwinklingDotsPainter(
              points: _points,
              minSize: 0.84,
              maxSize: 1,
            ),
          ),
        ),
      ],
    );
  }
}
