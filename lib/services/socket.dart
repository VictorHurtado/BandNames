import 'package:flutter/widgets.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  SocketService() {
    this._initConfig();
  }
  void _initConfig() {
    // Dart client
    IO.Socket socket = IO.io('http://10.0.2.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket.onConnect((_) {
      // ignore: avoid_print
      print('connect');
      socket.emit('msg', 'test');
    });

    socket.onDisconnect((_) => print('disconnect'));
  }
}
