import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];
  @override
  void initState() {
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.off('active-bands ');
    super.dispose();
  }

  _handleActiveBands(dynamic data) {
    bands = (data as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketService>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Center(
          child: Text(
            'Band Names Votes',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketProvider.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(size),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) =>
                    _bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (DismissDirection dismissDirection) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
          padding: EdgeInsets.only(left: 8),
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name!.substring(0, 2)),
            backgroundColor: Colors.blue.shade100,
          ),
          title: Text(band.name!),
          trailing: Text('${band.votes}'),
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id})),
    );
  }

  addNewBand() {
    final TextEditingController editingController = TextEditingController();
    if (!Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("New Band Name: "),
                content: TextField(
                  controller: editingController,
                ),
                actions: [
                  MaterialButton(
                      child: Text("Add"),
                      elevation: 5,
                      textColor: Colors.blue,
                      onPressed: () => addBandToList(editingController.text))
                ],
              ));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("New Band Name: "),
                content: CupertinoTextField(
                  controller: editingController,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Add"),
                    onPressed: () => addBandToList(editingController.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Dismiss"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
  }

  void addBandToList(String bandName) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (bandName.length > 1) {
      socketService.socket.emit('add-new', {'name': bandName});
    }

    Navigator.pop(context);
  }

  //grafica

  Widget _showGraph(Size size) {
    Map<String, double> dataMap = Map.fromEntries(
        bands.map((band) => MapEntry(band.name!, band.votes!.toDouble())));
    if (dataMap.isNotEmpty) {
      return SizedBox(
          width: double.infinity,
          height: size.height / 2.5,
          child: PieChart(dataMap: dataMap));
    } else {
      return Text("");
    }
  }
}
