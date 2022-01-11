import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', votes: 5),
    Band(id: '2', name: 'Bon Jovi', votes: 3),
    Band(id: '3', name: 'Heroes del Silencio', votes: 4),
    Band(id: '4', name: 'Soda Stereo', votes: 4),
  ];
  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (DismissDirection dismissDirection) {
        print("Direction ${dismissDirection} ${band.name}");

        //TODO: Crear eliminar del backend
      },
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
        onTap: () => print(band.name),
      ),
    );
  }

  addNewBand() {
    final TextEditingController editingController = TextEditingController();
    if (!Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
    if (bandName.length > 1) {
      print("Este es el nombre de la Banda: ${bandName}");
      this.bands.add(Band(
            id: DateTime.now().toString(),
            name: bandName,
          ));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
