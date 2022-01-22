import 'package:band_names/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SocketService socketService = Provider.of<SocketService>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("intentando");
          socketService.socket.emit("newMessage",
              {"nombre": "Flutter", "mensaje": "Hola desde Flutter! "});
        },
        child: const Icon(
          Icons.message,
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Server Status: ${socketService.serverStatus}")],
      )),
    );
  }
}
