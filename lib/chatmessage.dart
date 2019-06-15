import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ChatMessage extends StatelessWidget {
  final String name;
  final String text;
  final String icon;
  final String steamid;
  final bool self;

// constructor to get text from textfield
  ChatMessage(
      {this.name = 'Anonynmous',
      this.text,
      this.icon =
          'http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png',
      this.steamid,
      this.self = false});

  @override
  Widget build(BuildContext context) {
    var margin = EdgeInsets.only(right: 16);
    var textDirection = TextDirection.ltr;
    if (self) {
      margin = EdgeInsets.symmetric(vertical: 10);
      textDirection = TextDirection.rtl;
    }
    return Container(
        margin: margin,
        child: Row(
          textDirection: textDirection,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                child: Image.network(icon),
              ),
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    child: Text(name,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontFamily: 'Roboto')),
                    onTap: () async {
                      final url = 'http://steamcommunity.com/profiles/$steamid';
                      if (await launcher.canLaunch(url)) {
                        launcher.launch(url);
                      } else {
                        print('Failed to launch: $url');
                      }
                    }),
                Container(margin: EdgeInsets.only(top: 5), child: Text(text))
              ],
            ))
          ],
        ));
  }
}
