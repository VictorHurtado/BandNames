// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  // ignore: prefer_final_fields
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://10.0.2.2:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;

      print("conectado");
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    _socket.on('newMessage', (payload) {
      print("El nuevo mensaje es: ${payload["mensaje"]}");
    });
  }
}
