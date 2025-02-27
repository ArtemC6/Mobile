import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum EventType {
  connected,
  disconnected,
}

class WebSocket {
  WebSocket({required Uri uri}) {
    _uri = uri;
    _dataStreamController = StreamController<Map<String, dynamic>>.broadcast();
    _eventsStreamController = StreamController<EventType>.broadcast();
    _socket = WebSocketChannel.connect(_uri);
    _subscription = _socket.stream.listen(
      _onData,
      onDone: _reconnect,
      onError: _onError,
    );

    // _pingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
    //   if (currentState == EventType.connected) {
    //     if (_lastEcho
    //         .isBefore(DateTime.now().
    //         subtract(const Duration(seconds: 12)))) {
    //       _reconnect();
    //       } else {
    //         _sendPing();
    //     }
    //   }
    // });
  }

  late Uri _uri;
  late WebSocketChannel _socket;
  late StreamSubscription<dynamic> _subscription;
  // late final Timer _pingTimer;

  // DateTime _lastEcho = DateTime.now();

  late StreamController<Map<String, dynamic>> _dataStreamController;
  late StreamController<EventType> _eventsStreamController;
  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;
  Stream<EventType> get eventsStream => _eventsStreamController.stream;
  EventType get currentState => _currentState;
  EventType _currentState = EventType.connected;

  final Map<String, Request> requests = <String, Request>{};

  Future<void> _reconnect() async {
    _currentState = EventType.disconnected;
    _eventsStreamController.sink.add(EventType.disconnected);

    log('Reconnecting...', name: 'WS');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.log('WS: Reconnecting...');
    }

    await Future<void>.delayed(Duration(seconds: math.Random().nextInt(4) + 1));

    _socket = WebSocketChannel.connect(_uri);

    await _subscription.cancel();

    _subscription = _socket.stream.listen(
      _onData,
      onDone: _reconnect,
      onError: _onError,
    );

    _sendPing();

    _resendRequests();
  }

  Future<void> _onData(dynamic data) async {
    if (_currentState != EventType.connected) {
      _currentState = EventType.connected;
      _eventsStreamController.sink.add(EventType.connected);
    }

    // _lastEcho = DateTime.now();

    log('Received: $data', name: 'WS');
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.log('WS: Received: $data');
    }
    final map = json.decode(data as String) as Map<String, dynamic>;

    final key = "${map['Ticket']}/${map['OperationID']}/${map['Type']}";

    final request = requests[key];

    if (request != null) {
      request.task.complete(map);
      requests.remove(key);
    } else {
      // Ignore ping echo, lol
      if (map['Data'] !=
          "Undefined tickettoken: 'deadbeef-8a26-4e81-a1d4-d54fac67f915'") {
        _dataStreamController.sink.add(map);
      }
    }
  }

  void _onError(dynamic error) {
    log('Error: $error', name: 'WS');
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('WS: Error: $error');
    }
  }

  void _sendPing() {
    log('Ping', name: 'WS');
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('WS: Ping');
    }

    final data = <String, dynamic>{
      'Data': <String, dynamic>{
        'ChatID': 'deadbeef-c57d-434a-9408-5be8fd04fd11',
        'Status': 'read',
      },
      'TicketToken': 'deadbeef-8a26-4e81-a1d4-d54fac67f915',
      'Type': 'message',
    };

    _socket.sink.add(json.encode(data));
  }

  /// Fire and forget
  void send(Map<String, dynamic> data) {
    var l = data.toString();

    if (l.length > 300) {
      l = l.substring(0, 300);
    }

    log('Send: $l', name: 'WS');
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('WS: Send: $data');
    }

    if (_currentState == EventType.connected) {
      _socket.sink.add(json.encode(data));
    } else {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('WS: Not connected. Skipping...');
      }
      log('Not connected. Skipping...', name: 'WS');
    }
  }

  Future<Map<String, dynamic>> request(
    Map<String, dynamic> data,
    String ticket,
    String operationId,
  ) {
    final key = '$ticket/$operationId/${data['Type']}';

    if (requests.containsKey(key)) {
      throw Exception('Request is already in progress: `$key`');
    }

    final task = Completer<Map<String, dynamic>>();

    data['Ticket'] = ticket;
    data['OperationID'] = operationId;

    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('WS: Send and wait: $data');
    }

    log('Send and wait: $data', name: 'WS');

    requests[key] = Request(data, task);

    if (_currentState == EventType.connected) {
      _socket.sink.add(json.encode(requests[key]!.body));
    } else {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('WS: Not connected. Skipping...');
      }

      log('Not connected. Skipping...', name: 'WS');
    }

    return task.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () async {
        requests.remove(key);

        throw TimeoutException('494dd145: WebSocket timeout');
      },
    );
  }

  void _resendRequests() {
    for (final r in requests.values) {
      log('Resend and wait: ${r.body}', name: 'WS');

      _socket.sink.add(json.encode(r.body));
    }
  }

  Future<dynamic> close() async {
    // _pingTimer.cancel();
    await _dataStreamController.sink.close();
    await _socket.sink.close();
  }
}

class Request {
  Request(this.body, this.task);

  final Map<String, dynamic> body;
  final Completer<Map<String, dynamic>> task;
}
