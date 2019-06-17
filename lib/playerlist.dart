import 'package:sourcemod_liveview/player.dart';
import 'package:sourcemod_liveview/socket.dart';
import 'package:flutter/material.dart';

class PlayerList extends StatefulWidget {
  @override
  State<PlayerList> createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList> {
  final _serverSocket = ServerSocket();
  List<Player> _players = <Player>[];

  @override
  void initState() {
    super.initState();

    _serverSocket.onUpdatePlayer.listen((player) {
      if (!mounted) {
        return;
      }

      setState(() {
        _players.add(player);
      });
    });

    _serverSocket.onPlayerJoin.listen((player) {
      if (!mounted) {
        return;
      }

      setState(() {
        _players.add(player);
      });
    });

    _serverSocket.onPlayerQuit.listen((userid) {
      if (!mounted) {
        return;
      }

      setState(() {
        _players.removeWhere((player) => player.userid == userid);
      });
    });

    _serverSocket.onPlayerChangeTeam.listen((data) {
      if (!mounted) {
        return;
      }

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
    });

    _serverSocket.onPlayerChangeAliveStatus.listen((data) {
      if (!mounted) {
        return;
      }

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
    });
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
