import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sourcemod_liveview/drawer.dart';
import 'package:sourcemod_liveview/socket.dart';

import 'chatscreen.dart';
import 'utilis.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // This widget is the root of your application.

  final _serverSocket = ServerSocket();

  String _steamid;

  @override
  void initState() {
    super.initState();

    onSteamIDUpdate.listen((steamid) {
      setState(() {
        _steamid = steamid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];

    actions.add(IconButton(
      onPressed: () async {
        _serverSocket.write(jsonEncode({'type': 4}));
        Navigator.pushNamed(context, '/list');
      },
      icon: Icon(Icons.list),
    ));

    actions.add(IconButton(
      onPressed: () async {
        await _serverSocket.reloadSocket();
        Alert(
          context: context,
          title: 'Success',
          desc: 'Connection reloaded successfully!',
          type: AlertType.success,
        ).show();
      },
      icon: Icon(Icons.cached),
    ));

    if (_steamid != null && _steamid.isNotEmpty) {
      actions.add(IconButton(
        onPressed: () async {
          addSteamID(null);
        },
        icon: Icon(Icons.exit_to_app),
      ));
    } else {
      actions.add(IconButton(
        onPressed: () async {
          Navigator.pushNamed(context, '/login');
        },
        icon: Icon(Icons.send),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Jailbreak Chat'),
          actions: actions,
        ),
        body: ChatScreen(),
        drawer: MyDrawer());
  }
}
