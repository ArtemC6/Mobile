import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';

class FeedPage {
  const FeedPage({
    required this.isLoading,
    this.items = const [],
  });

  final List<FeedModel> items;

  bool get isFull => items.length == FeedCubit.itemsPerPage;

  final bool isLoading;
}
