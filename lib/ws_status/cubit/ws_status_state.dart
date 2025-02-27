part of 'ws_status_cubit.dart';

class WsStatusState extends Equatable {
  const WsStatusState({
    this.wsLastEvent,
  });

  final EventType? wsLastEvent;

  WsStatusState copyWith({
    EventType? wsLastEvent,
  }) {
    return WsStatusState(
      wsLastEvent: wsLastEvent ?? this.wsLastEvent,
    );
  }

  @override
  List<Object?> get props => [wsLastEvent];
}
