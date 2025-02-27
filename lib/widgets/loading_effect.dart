import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:shimmer/shimmer.dart';

//----------------------- Loading Screens  (Shimmer Effects) ---------------------------//

class LoadingEffect {
  static Widget getSearchLoadingScreen(
    BuildContext context,
    ThemeData themeData, {
    int itemCount = 4,
  }) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    final Widget singleLoading = Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        height: 96,
        padding: FxSpacing.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              color: Colors.grey,
            ),
            Expanded(
              child: Container(
                height: 56,
                padding: FxSpacing.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.topLeft,
                            height: 8,
                            color: Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              FeatherIcons.heart,
                              color: themeData.colorScheme.onBackground,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Container(
                            height: 8,
                            color: Colors.grey,
                          ),
                        ),
                        const Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Container(
                            height: 8,
                            color: Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 8,
                              width: 36,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final list = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      list.add(
        Container(
          padding: FxSpacing.fromLTRB(16, 8, 16, 8),
          child: singleLoading,
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: list,
      ),
    );
  }

  static Widget getPlaylistLoadingScreen(
    BuildContext context,
    ThemeData themeData,
  ) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey,
                ),
                FxSpacing.width(
                  MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.grey,
                ),
                FxSpacing.width(
                  MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget getConfirmPaymentLoadingScreen(
    BuildContext context,
    ThemeData themeData,
  ) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        padding: FxSpacing.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget getNewChallengesDiscoveryLoading(ThemeData themeData) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    const items = 3;

    final challengeLoadingWidget = Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: SizedBox(
        width: 340,
        height: 136,
        child: Stack(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 24,
                left: 8,
              ),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final list = <Widget>[];
    for (var i = 0; i < items; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.all(8),
          child: challengeLoadingWidget,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list,
      ),
    );
  }

  static Widget getNewPlaylistsDiscoveryLoading(ThemeData themeData) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    const items = 3;
    final playlistLoadingWidget = Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: SizedBox(
        width: 200,
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );

    final list = <Widget>[];
    for (var i = 0; i < items; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.all(16),
          child: playlistLoadingWidget,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list,
      ),
    );
  }

  static Widget getDiscoveryLoading(
    ThemeData themeData,
    BuildContext context,
  ) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                    ),
                    child: FxContainer(
                      height: 120,
                      width: 120,
                    ),
                  ),
                );
              },
            ),
          ),
          FxSpacing.height(60),
          Center(
            child: Wrap(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth < 600 ? 2 : 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: const FxContainer(
                        height: 200,
                        width: 200,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          FxSpacing.height(60),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                    ),
                    child: FxContainer(
                      height: 120,
                      width: 120,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget getRecomendationsLoading(
    ThemeData themeData,
    BuildContext context,
  ) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Wrap(
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600 ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: const FxContainer(
                  height: 200,
                  width: 200,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget getClassroomsLoading(ThemeData themeData) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Padding(
      padding: const EdgeInsets.only(bottom: 50, top: 40),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: const Padding(
                padding: EdgeInsets.only(
                  right: 8,
                ),
                child: FxContainer(
                  height: 120,
                  width: 120,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget getFeedResultsLoading(
    BuildContext context,
  ) {
    final themeData = Theme.of(context);
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: const Padding(
              padding: EdgeInsets.only(
                right: 8,
              ),
              child: FxContainer(
                height: 120,
                width: 120,
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget getComplitedPlansLoading(ThemeData themeData) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: FxContainer(
          height: 180,
        ),
      ),
    );
  }

  static Widget getComplitedPlanLoading(
    BuildContext context,
    ThemeData themeData,
  ) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: FxContainer(
          height: 500,
          width: MediaQuery.sizeOf(context).width,
        ),
      ),
    );
  }

  static Widget getClassroomDetailsLoading(ThemeData themeData) {
    final shimmerBaseColor = themeData.brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF1a1a1a);

    final shimmerHighlightColor = themeData.brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF454545);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView(
        children: [
          Padding(
            padding: FxSpacing.only(
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.titleMedium(
                  'Plans',
                  fontWeight: 700,
                  textScaleFactor: 1.2257,
                  color: themeData.colorScheme.onBackground,
                ),
              ],
            ),
          ),
          Column(
            children: [
              FxContainer(
                padding: FxSpacing.fromLTRB(12, 20, 12, 20),
                margin: FxSpacing.nTop(20),
                borderRadiusAll: 16,
                color: themeData.colorScheme.primaryContainer,
                child: const SizedBox(height: 40, width: 347.4),
              ),
            ],
          ),
          Padding(
            padding: FxSpacing.only(
              left: 16,
              right: 16,
              top: 4,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.titleMedium(
                  'People',
                  fontWeight: 700,
                  color: themeData.colorScheme.onBackground,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 144,
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FxCard(
                color: themeData.colorScheme.surface,
                width: 144,
                margin: const EdgeInsets.only(left: 16),
                paddingAll: 0,
                borderRadiusAll: 8,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/Ccvoccentbg.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      height: 90,
                    ),
                    FxContainer(
                      color: Colors.transparent,
                      paddingAll: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodySmall(
                            '',
                            fontWeight: 500,
                            color: themeData.colorScheme.onSurface,
                          ),
                          FxSpacing.height(4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FxText.bodySmall(
                                '',
                                fontWeight: 700,
                                color: themeData.colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: FxSpacing.only(
              left: 16,
              top: 24,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.titleMedium(
                  'Campuses',
                  fontWeight: 700,
                  color: themeData.colorScheme.onBackground,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 144,
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FxCard(
                color: themeData.colorScheme.surface,
                width: 144,
                margin: const EdgeInsets.only(left: 16),
                paddingAll: 0,
                borderRadiusAll: 8,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/Ccvoccentbg.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      height: 90,
                    ),
                    FxContainer(
                      color: Colors.transparent,
                      paddingAll: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodySmall(
                            '',
                            fontWeight: 500,
                            color: themeData.colorScheme.onSurface,
                          ),
                          FxSpacing.height(4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FxText.bodySmall(
                                '',
                                fontWeight: 700,
                                color: themeData.colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
