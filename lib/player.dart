import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class Player extends StatefulWidget {
  final int userid;
  final String name;
  final bool alive;
  final int team;
  final String icon;
  final String steamid;

  Player(
      {Key key,
      this.userid,
      this.name,
      this.alive,
      this.team,
      this.icon,
      this.steamid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PlayerState();

  Player.fromMap(Map<String, dynamic> map)
      : userid = map['userid'],
        name = map['name'],
        alive = map['alive'],
        team = map['team'],
        icon = map['icon'],
        steamid = map['steamid'];

  static Player fromPlayer(Player player,
          {int userid,
          String name,
          bool alive,
          int team,
          String icon,
          String steamid}) =>
      Player(
          userid: userid ?? player.userid,
          name: name ?? player.name,
          alive: alive ?? player.alive,
          team: team ?? player.team,
          icon: icon ?? player.icon,
          steamid: steamid ?? player.steamid);
}

class PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: CircleAvatar(
            child: Image.network(widget.icon),
          ),
        ),
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
                child: Text(widget.name,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'Roboto')),
                onTap: () async {
                  final url =
                      'http://steamcommunity.com/profiles/${widget.steamid}';
                  if (await launcher.canLaunch(url)) {
                    launcher.launch(url);
                  } else {
                    print('Failed to launch: $url');
                  }
                }),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(children: <Widget>[
                AutoSizeText(widget.alive ? 'Alive' : 'Death',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent)),
                AutoSizeText(' Team:'),
                AutoSizeText(teamToString(widget.team),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent)),
              ]),
            )
          ],
        ))
      ],
    ));
  }

  String teamToString(int team) {
    if (team == 0) {
      return 'None';
    } else if (team == 1) {
      return 'Spectator';
    } else if (team == 2) {
      return 'Prisoner';
    } else if (team == 3) {
      return 'Guard';
    }
    return null;
  }
}
