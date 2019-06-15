import 'dart:convert';

<<<<<<< HEAD

import 'package:sourcemod_liveview/drawer.dart';
import 'package:sourcemod_liveview/socket.dart';

=======
>>>>>>> ec999fd... Update
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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

  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final _serverSocket = ServerSocket();

  String _steamid;

  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
    flutterWebviewPlugin.onUrlChanged.listen((url) async {
      print('URL changed to $url');
      final openid = OpenId.fromUri(Uri.parse(url));
      if (openid.mode == 'id_res') {
        print('Closing...');
        flutterWebviewPlugin.close();
        Navigator.popAndPushNamed(context, '/');

        var prefs = await SharedPreferences.getInstance();
        final steamid = await openid.validate();
        await prefs.setString('steamid', steamid);

        setState(() {
          _steamid = steamid;
        });
      } else {
        print('Failed...');

        await flutterWebviewPlugin.close();
        await Navigator.popAndPushNamed(context, '/');
        Alert(context: context, title: 'Login failed!', desc: 'Failed: ${openid.mode}');
      }
    });

    flutterWebviewPlugin.onHttpError.listen((error) => print('HTTP Error: ${error.url} ${error.code}'));
    flutterWebviewPlugin.onStateChanged.listen((state) => print('STATE Change: ${state.url} ${state.type}'));

    SharedPreferences.getInstance().then((prefs) {
=======
    onSteamIDUpdate.listen((steamid) {
>>>>>>> ec999fd... Update
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
<<<<<<< HEAD
          setState(() {
            _steamid = null;
          });
          var prefs = await SharedPreferences.getInstance();
          await prefs.remove('steamid');
=======
          addSteamID(null);
>>>>>>> ec999fd... Update
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
