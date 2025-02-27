import 'dart:async';

import 'package:flutter/material.dart';

/// Basic state with scroll controller and pagination tracking
/// This is an abstract class that needs to be used in a StatefulWidget
/// where a list is rendered,
/// !!! replacing the basic state with PaginationListenerState

abstract class PaginationListenerState<T extends StatefulWidget>
    extends State<T> {
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  final ValueNotifier<bool> showScrollToStartButton =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    scrollController
      ..addListener(_onScroll)
      ..addListener(_checkScrollToStartButtonVisibility);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..removeListener(_checkScrollToStartButtonVisibility)
      ..dispose();
    _debounce?.cancel();
    showScrollToStartButton.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isEnd) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 100), onFetched);
    }
    _checkScrollToStartButtonVisibility();
  }

  void _checkScrollToStartButtonVisibility() {
    final currentScroll = scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.width * 0.1;

    showScrollToStartButton.value = currentScroll > delta;
  }

  Future<void> onFetched();

  bool get _isEnd {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.1);
  }
}
