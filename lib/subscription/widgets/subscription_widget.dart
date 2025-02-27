import 'dart:io';
import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/subscription/cubit/constants.dart';
import 'package:voccent/subscription/cubit/models/purchasable_product.dart';
import 'package:voccent/subscription/cubit/models/store_state.dart';
import 'package:voccent/subscription/cubit/subscription_cubit.dart';
import 'package:voccent/widgets/animation_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/web_view_widget.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 74,
                          sigmaY: 74,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                              0.5,
                            ),
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            'assets/images/Ccwhitebg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const _AnimationBackground(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
              S.current.payments.toUpperCase(),
              fontWeight: 600,
              textScaleFactor: 1.2257,
              color: mTheme.primary,
            ),
          ),
          body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
            builder: (context, state) {
              switch (state.storeState) {
                case StoreState.loading:
                  return Padding(
                    padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 16),
                    child: LoadingEffect.getSearchLoadingScreen(
                      context,
                      theme,
                    ),
                  );
                case StoreState.available:
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        Text(
                          S.current.subscriptionDescriptionFreePlan1,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.current.subscriptionDescriptionFreePlan2,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.current.subscriptionDescriptionFreePlan4,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimationLimiter(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.products.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(
                                  milliseconds: 200,
                                ),
                                child: SlideAnimation(
                                  duration: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  verticalOffset: width / 1.6,
                                  child: FadeInAnimation(
                                    curve: Curves.easeOut,
                                    duration: const Duration(
                                      milliseconds: 2700,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildSinglePlan(
                                        state.products[index],
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        DelayedDisplay(
                          delay: const Duration(milliseconds: 900),
                          slidingBeginOffset: const Offset(0.35, 0.35),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 22,
                                ),
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
                                    child: FxText.bodyMedium(
                                      S.current.genericTermsAndConditions,
                                      color: Colors.white,
                                      fontWeight: 800,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push<void>(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const WebViewWidget(
                                        'https://www.voccent.com/privacy-policy.html',
                                      ),
                                    ),
                                  ),
                                  child: FxText.bodyMedium(
                                    S.current.genericPrivacyPolicy,
                                    color: Colors.white,
                                    fontWeight: 800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FxSpacing.height(16),
                      ],
                    ),
                  );
                case StoreState.notAvailable:
                  return _PurchasesNotAvailable();
              }
            },
          ),
        ),
      ],
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

  return FlutterColorsBorder(
    boardRadius: 8,
    size: Size(
      width,
      190,
    ),
    available: purchased,
    borderWidth: 1.6,
    colors: [
      mTheme.primary,
      mTheme.onSurface.withOpacity(0.15),
      mTheme.primary,
      mTheme.onSurface.withOpacity(0.1),
      mTheme.primary,
    ],
    child: FxContainer.bordered(
      onTap: () {
        if (!purchased) {
          if (product.id == storeKeySubscriptionFree) {
            // The app can't cancel subscription:
            // https://github.com/flutter/flutter/issues/58834

            showDialog<_SimpleDialog>(
              context: context,
              builder: (BuildContext context) => _SimpleDialog(),
            );
          } else {
            context.read<SubscriptionCubit>().buy(product);
          }
        }
      },
      border: Border.all(
        color: Colors.white,
      ),
      bordered: !purchased,
      color: Colors.transparent,
      borderRadiusAll: 8,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FxText.titleMedium(
                    product.title,
                    color: mTheme.secondary,
                    fontWeight: purchased ? 700 : 500,
                    fontSize: 26,
                    letterSpacing: 0.3,
                  ),
                ),
                if (purchased)
                  FxContainer(
                    bordered: true,
                    borderRadiusAll: 8,
                    borderColor: mTheme.primary,
                    padding: FxSpacing.xy(32, 10),
                    child: FxText.labelLarge(
                      S.current.subscriptionActive,
                      color: mTheme.secondary,
                    ),
                  ),
                if (!purchased)
                  FxContainer(
                    borderRadiusAll: 8,
                    color: mTheme.primary,
                    padding: FxSpacing.xy(32, 10),
                    child: FxText.labelLarge(
                      S.current.subscriptionSwitch,
                      color: mTheme.onPrimary,
                    ),
                  ),
              ],
            ),
            FxSpacing.height(8),
            if (!freePlan)
              Row(
                children: [
                  FxText.headlineSmall(
                    product.price,
                    color: Colors.white,
                  ),
                  FxText.bodySmall(
                    S.current.subscriptionMonth,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ],
              ),
            FxSpacing.height(8),
            Row(
              children: [
                if (!freePlan)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.current.subscriptionDescription7DaysGrace,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getDescriptionForPlan(product.productDetails.title),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (freePlan)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          S.current.subscriptionDescriptionFreePlan3,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
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
          ],
        ),
      ),
    ),
  );
}

class _PurchasesNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store not available'));
  }
}

class _AnimationBackground extends StatefulWidget {
  const _AnimationBackground();

  @override
  _AnimationBackgroundState createState() => _AnimationBackgroundState();
}

class _AnimationBackgroundState extends State<_AnimationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 8).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.transparent,
                if (Theme.of(context).brightness == Brightness.dark)
                  Colors.black
                else
                  Colors.white,
              ],
              stops: const [0.06, 1],
              radius: 1.14 + _animation.value, // Increased radius
            ),
          ),
        ),
      );
}
