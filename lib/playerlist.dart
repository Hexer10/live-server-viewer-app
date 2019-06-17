import 'dart:async';

import 'package:sourcemod_liveview/player.dart';
import 'package:sourcemod_liveview/socket.dart';
import 'package:flutter/material.dart';

class PlayerList extends StatefulWidget {
  @override
  State<PlayerList> createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList> {
  final _serverSocket = ServerSocket();
  final List<Player> _players = <Player>[];
  final List<StreamSubscription> _subs = [];

  var _warnText = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _subs.add(_serverSocket.onUpdatePlayer.listen((player) {
      setState(() {
        _players.add(player);
      });
    }));

    _subs.add(_serverSocket.onPlayerJoin.listen((player) {
      _timer.cancel();
      setState(() {
        _players.add(player);
      });
    }));

    _subs.add(_serverSocket.onPlayerQuit.listen((userid) {
      setState(() {
        _players.removeWhere((player) => player.userid == userid);
      });
      if (_players.isEmpty) {
        _startTimer();
      }
    }));

    _subs.add(_serverSocket.onPlayerChangeTeam.listen((data) {
      setState(() {
        // TODO(Hexah): Temporary workaround.
        var index =
            _players.indexWhere((player) => player.userid == data.first);
        if (index == -1) {
          return;
        }

        var player = _players.removeAt(index);
        _players.insert(index, Player.fromPlayer(player, team: data[1]));
      });
    }));

    _subs.add(_serverSocket.onPlayerChangeAliveStatus.listen((data) {
      setState(() {
        // TODO(Hexah): Temporary workaround.
        var index =
            _players.indexWhere((player) => player.userid == data.first);
        if (index == -1) {
          return;
        }
        var player = _players.removeAt(index);
        _players.insert(index, Player.fromPlayer(player, alive: data[1]));
      });
    }));
    _startTimer();
  }

  void _startTimer() {
    //Avoid two running timers.
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 8), () {
      setState(() {
        _warnText =
            'The server might be empty or the connection to the socket has failed...';
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    for (var sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Playerlist'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: _players.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.lightBlueAccent))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Text(_warnText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      height: 0.8,
                                      color: Colors.lightBlue,
                                      fontFamily: 'Hind')))
                        ]))
                  : ListView.separated(
                      padding: EdgeInsets.all(8),
                      itemBuilder: (_, index) => _players[index],
                      itemCount: _players.length,
                      separatorBuilder: (_, index) => Divider(
                        color: Colors.black,
                      ),
                    ),
            )
          ],
        ));
  }
}
