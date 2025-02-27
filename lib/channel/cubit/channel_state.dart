part of 'channel_cubit.dart';

class ChannelState extends Equatable {
  const ChannelState({
    this.query = '',
    this.tab = FeedTab.feed,
    this.pages = const <int, FeedPage>{},
    this.channel,
    this.channelSummary,
  });

  final String query;
  final FeedTab tab;
  final Map<int, FeedPage> pages;
  final FeedObject? channel;
  final ChannelSummary? channelSummary;

  int? get itemsCount {
    if (pages.values.any((element) => !element.isFull && !element.isLoading)) {
      return pages.values
          .map((e) => e.items.length)
          .reduce((value, element) => value + element);
    }

    return null;
  }

  @override
  List<Object?> get props => [
        query,
        tab,
        pages,
        channel,
        channelSummary,
      ];

  ChannelState copyWith({
    String? query,
    FeedTab? tab,
    Map<int, FeedPage>? pages,
    FeedObject? channel,
    ChannelSummary? channelSummary,
  }) {
    return ChannelState(
      query: query ?? this.query,
      tab: tab ?? this.tab,
      pages: pages ?? this.pages,
      channel: channel ?? this.channel,
      channelSummary: channelSummary ?? this.channelSummary,
    );
  }
}
