import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/web_socket/web_socket.dart';

part 'ws_status_state.dart';

class WsStatusCubit extends Cubit<WsStatusState> {
  WsStatusCubit(
    this._socket,
  ) : super(const WsStatusState()) {
    _wsEventsSubscription = _socket.eventsStream.listen(_onWsEvent);
  }

  final WebSocket _socket;
  late final StreamSubscription<EventType> _wsEventsSubscription;

  void _onWsEvent(EventType event) {
    emit(state.copyWith(wsLastEvent: event));
  }

  @override
  Future<void> close() {
    _wsEventsSubscription.cancel();
    return super.close();
  }
}
