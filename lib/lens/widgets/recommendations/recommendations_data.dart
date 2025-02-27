part of 'package:voccent/lens/lens_library.dart';

class RecommedationsData {
  RecommedationsData({
    required this.itemType,
    required this.itemId,
    required this.currentIndex,
    required this.items,
  });
  final RecommendationItemType itemType;
  final String itemId;
  final int currentIndex;
  final List<RecommendationsItem> items;
}
