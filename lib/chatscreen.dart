import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourcemod_liveview/socket.dart';
import 'package:sourcemod_liveview/utilis.dart';

import 'chatmessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  ServerSocket socket;

  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  StreamSubscription _messageSub;
  String _name;
  String _icon;

  static final _key = apikey;

  Future<void> _handleSubmit(String text, BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final steamid = prefs.getString('steamid');
    if (steamid == null || steamid.isEmpty) {
      Alert(
              context: context,
              title: 'Error',
              desc: 'You must login with steam in order to send messages!',
              type: AlertType.error)
          .show();
      return;
    }

    if (text.trim().isEmpty) {
      Alert(
              context: context,
              title: 'Error',
              desc: 'Empty text!',
              type: AlertType.error)
          .show();
      return;
    }

    if (_name == null) {
      var response = await http.get(
          'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$_key&steamids=$steamid');
      var info = jsonDecode(response.body);
      _name = info['response']['players'][0]['personaname'];
      _icon = info['response']['players'][0]['avatarfull'];
    }

    socket.write(jsonEncode(
        {'name': _name, 'message': text, 'steamid': steamid, 'type': 0}));
    _chatController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      icon: _icon,
      name: _name,
      self: true,
      steamid: steamid,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  void initState() {
    super.initState();
    socket = ServerSocket();

    socket.initSocket().then((_) {
      socket.onConnection.listen((_) => Alert(
              context: context,
              title: 'Success',
              desc: 'Connected to server successfully!',
              type: AlertType.success)
          .show());

      socket.onConnectionClose.listen((_) => Alert(
              context: context,
              title: 'Warning',
              desc: 'Connection closed!',
              type: AlertType.warning)
          .show());


      _messageSub = socket.onChatMessage.listen((message) {
        setState(() {
          _messages.insert(0, message);
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageSub.cancel();
  }

  Widget _chatEnvironment() => IconTheme(
        data: IconThemeData(color: Colors.blue),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: 'Starts typing ...'),
                  controller: _chatController,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmit(_chatController.text, context),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            reverse: true,
            itemBuilder: (_, index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _chatEnvironment(),
        )
      ],
    );
  }
}
