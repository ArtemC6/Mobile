// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:voccent/challenge/widgets/rive_comparison_animation.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/subscription/cubit/constants.dart';
import 'package:voccent/subscription/cubit/models/purchasable_product.dart';
import 'package:voccent/subscription/cubit/models/store_state.dart';
import 'package:voccent/subscription/cubit/subscription_cubit.dart';

void startOverDialogBlur(
  BuildContext context,
  StoryState storyState,
  String? planPassElementId,
) {
  showDialog<void>(
    context: context,
    builder: (notThisContext) => Platform.isIOS
        ? _dialogIos(context, planPassElementId)
        : _dialogAndroid(context, planPassElementId),
  );
}

CupertinoAlertDialog _dialogIos(
  BuildContext context,
  String? planPassElementId,
) {
  return CupertinoAlertDialog(
    title: Text(S.current.startOver),
    actions: <CupertinoDialogAction>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(S.current.genericCancel),
      ),
      CupertinoDialogAction(
        isDestructiveAction: true,
        onPressed: () {
          context
              .read<StoryCubit>()
              .restart(planPassElementId: planPassElementId);
          Navigator.pop(context);
        },
        child: Text(S.current.storyStart),
      ),
    ],
  );
}

Widget _dialogAndroid(BuildContext context, String? planPassElementId) {
  final theme = Theme.of(context);
  return Dialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Container(
      padding: FxSpacing.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
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
                  child:
                      FxText.titleLarge(S.current.startOver, fontWeight: 600),
                ),
              ),
            ],
          ),
          const Divider(),
          Container(
            margin: FxSpacing.top(24),
            alignment: AlignmentDirectional.centerEnd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FxButton.text(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: FxText.bodyMedium(
                    S.current.genericCancel,
                    fontWeight: 600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                FxButton(
                  backgroundColor: theme.colorScheme.primary,
                  borderRadiusAll: 4,
                  elevation: 0,
                  onPressed: () {
                    context
                        .read<StoryCubit>()
                        .restart(planPassElementId: planPassElementId);
                    Navigator.pop(context);
                  },
                  child: FxText.bodyMedium(
                    S.current.storyStart,
                    fontWeight: 600,
                    color: theme.colorScheme.onPrimary,
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

void showInfoDialog(
  BuildContext context,
  String infoText,
  String? infoPercent,
) {
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfo(
        infoText: infoText,
        infoPercent: infoPercent,
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(
    const Duration(milliseconds: 2000),
    () => overlayEntry.remove(),
  );
}

void showInfoWaitDialog(
  BuildContext context,
) {
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfo(
        infoText: S.current.wait,
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(
    const Duration(milliseconds: 2000),
    () {
      overlayEntry.remove();
    },
  );
}

void showInfoPlan(
  BuildContext context,
  String infoText,
) {
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: TopPanelInfoPlan(
        infoText: infoText,
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(
    const Duration(milliseconds: 3000),
    () {
      overlayEntry.remove();
    },
  );
}

class Sprung extends Curve {
  factory Sprung([double damping = 20]) => Sprung.custom(damping: damping);

  Sprung.custom({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) : _sim = SpringSimulation(
          SpringDescription(
            damping: damping,
            mass: mass,
            stiffness: stiffness,
          ),
          0,
          1,
          velocity,
        );

  final SpringSimulation _sim;

  @override
  double transform(double t) => _sim.x(t) + t * (1 - _sim.x(1));
}

class TopPanelProgress extends StatefulWidget {
  const TopPanelProgress({required this.refDuration, super.key});

  final Duration refDuration;

  @override
  State<TopPanelProgress> createState() => TopPanelProgressState();
}

class TopPanelProgressState extends State<TopPanelProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.refDuration,
    )..addListener(() => setState(() {}));

    _animation = Tween<double>(
      begin: (recordingOvertime + widget.refDuration).inMilliseconds.toDouble(),
      end: 0,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          alignment: Alignment.center,
          height: 160,
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: LinearProgressIndicator(
                      value: _animation.value /
                          (recordingOvertime + widget.refDuration)
                              .inMilliseconds
                              .toDouble(),
                      minHeight: 160,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.3),
                      ),
                    ),
                  ),
                  FxText.bodyLarge(
                    (_animation.value / 1000).toStringAsFixed(1),
                    fontWeight: 700,
                    fontSize: 62,
                    color: Colors.white,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class TopPanelInfoPlan extends StatefulWidget {
  const TopPanelInfoPlan({
    required this.infoText,
    super.key,
  });

  final String infoText;

  @override
  TopPanelInfoPlanState createState() => TopPanelInfoPlanState();
}

class TopPanelInfoPlanState extends State<TopPanelInfoPlan>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 240,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 160,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
              ),
              FadeTransition(
                opacity: _opacityAnimation,
                child: FxText.bodyLarge(
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  widget.infoText,
                  fontWeight: 900,
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TopPanelInfo extends StatefulWidget {
  const TopPanelInfo({required this.infoText, super.key, this.infoPercent});

  final String infoText;
  final String? infoPercent;

  @override
  TopPanelInfoState createState() => TopPanelInfoState();
}

class TopPanelInfoState extends State<TopPanelInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 160,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 62, sigmaY: 62),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 160,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
              ),
              FadeTransition(
                opacity: _opacityAnimation,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: FxText.bodyLarge(
                    widget.infoText,
                    fontWeight: 900,
                    fontSize: 52,
                    color: Theme.of(context).colorScheme.secondary,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 12),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: FxText.bodyLarge(
                      widget.infoPercent != null ? widget.infoPercent! : '',
                      fontWeight: 900,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SubscriptionDialog extends StatefulWidget {
  const SubscriptionDialog({super.key});

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  double result = 0;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * width, 0),
          child: Opacity(
            opacity: _fadeInAnimation.value,
            child: SizedBox(
              height: 380,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 330,
                        width: width,
                        child: Stack(
                          children: <Widget>[
                            Transform.scale(
                              scale: 1.2,
                              child: Lottie.asset(
                                'assets/lottie/subscription.json',
                                height: 340,
                                width: width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              child: BlocConsumer<SubscriptionCubit,
                                  SubscriptionState>(
                                listenWhen: (previous, current) =>
                                    previous.storeState != current.storeState ||
                                    previous.subscription?.subscriptionExists !=
                                        current
                                            .subscription?.subscriptionExists ||
                                    previous.subscription?.subscriptionCurrent
                                            ?.tariffCurrencyId !=
                                        current
                                            .subscription
                                            ?.subscriptionCurrent
                                            ?.tariffCurrencyId,
                                listener: (context, state) {
                                  if ((state.subscription?.subscriptionCurrent
                                                  ?.tariffCurrencyId ??
                                              '')
                                          .isNotEmpty &&
                                      state.storeState ==
                                          StoreState.available) {
                                    setState(() => result = 100);
                                  }
                                },
                                builder: (context, state) {
                                  switch (state.storeState) {
                                    case StoreState.loading:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case StoreState.available:
                                      final elementCurrent =
                                          state.products.firstWhere(
                                        (element) =>
                                            element.status ==
                                            ProductStatus.purchased,
                                      );

                                      final indexCurrent = state.products
                                          .indexOf(elementCurrent);

                                      var index = 1;

                                      if (indexCurrent == 3) {
                                        index = 3;
                                      } else {
                                        index = index + 1;
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        child: _buildSinglePlan(
                                          state.products[index],
                                          context,
                                        ),
                                      );
                                    case StoreState.notAvailable:
                                      return _PurchasesNotAvailable();
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RiveComparisonAnimation(
                    percentage: result,
                    artboard: 'confetti',
                    key: ValueKey(
                      result,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSinglePlan(
    PurchasableProduct product,
    BuildContext context,
  ) {
    final mTheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    final purchased = product.status == ProductStatus.purchased;
    final freePlan = product.productDetails.id == storeKeySubscriptionFree;

    String getDescriptionForPlan(String planType) {
      if (planType.contains('Basic')) {
        return S.current.subscriptionDescriptionBasicPlan;
      } else if (planType.contains('Standard')) {
        return S.current.subscriptionDescriptionStandardPlan;
      } else if (planType.contains('Advanced')) {
        return S.current.subscriptionDescriptionAdvancedPlan;
      } else {
        return 'Select a plan to see detailed information and features.';
      }
    }

    return FxContainer(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                product.title,
                textScaleFactor: 1,
                style: TextStyle(
                  color: mTheme.secondary,
                  fontWeight: FontWeight.w900,
                  fontSize: 34,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            if (!freePlan)
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    FxText.headlineSmall(
                      product.price,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      fontWeight: 900,
                      color: Colors.white,
                    ),
                    FxSpacing.width(1),
                    FxText.bodySmall(
                      overflow: TextOverflow.ellipsis,
                      S.current.subscriptionMonth,
                      textScaleFactor: 1,
                      letterSpacing: 0,
                      fontWeight: 700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            FxSpacing.height(4),
            SizedBox(
              height: 92,
              child: Row(
                children: [
                  if (!freePlan)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.subscriptionDescription7DaysGrace,
                            textScaleFactor: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            getDescriptionForPlan(product.productDetails.title),
                            textScaleFactor: 1,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            S.current.subscriptionDescriptionFreePlan3,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            S.current.subscriptionDescriptionFreePlan5,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (purchased)
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push('/profile/subscriptions'),
                  child: FxContainer(
                    width: width,
                    borderRadiusAll: 8,
                    color: Colors.white,
                    padding: FxSpacing.xy(22, 12),
                    child: FxText.labelLarge(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      S.current.chooseDifferentPaymentPlan,
                      color: Colors.black,
                      fontSize: 18,
                      textScaleFactor: 1,
                      maxLines: 2,
                      fontWeight: 700,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GestureDetector(
                  onTap: () {
                    if (!purchased) {
                      if (product.id == storeKeySubscriptionFree) {
                        showDialog<_SimpleDialog>(
                          context: context,
                          builder: (BuildContext context) => _SimpleDialog(),
                        );
                      } else {
                        context.read<SubscriptionCubit>().buy(product);
                      }
                    }
                  },
                  child: FxContainer(
                    width: width,
                    borderRadiusAll: 12,
                    color: Colors.white,
                    padding: FxSpacing.xy(32, 10),
                    child: FxText.labelLarge(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      '${S.current.subscribeTo} ${product.title}',
                      color: Colors.black,
                      fontSize: 16,
                      textScaleFactor: 1,
                      maxLines: 1,
                      fontWeight: 800,
                    ),
                  ),
                ),
              ),
            FxSpacing.height(12),
            if (!purchased)
              SizedBox(
                width: width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 0.6,
                      ),
                    ),
                  ),
                  onPressed: () =>
                      GoRouter.of(context).push('/profile/subscriptions'),
                  child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    S.current.chooseDifferentPaymentPlan,
                    textScaleFactor: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SimpleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FxText.titleMedium(
              Platform.isIOS
                  ? 'To downgrade to Free plan, '
                      'please cancel the subscription in App Store'
                  : 'To downgrade to Free plan, '
                      'please cancel the subscription in Google Play',
            ),
            const SizedBox(height: 12),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: FxText.bodyMedium(
                  'OK',
                  letterSpacing: 0.3,
                  fontWeight: 600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store not available'));
  }
}
