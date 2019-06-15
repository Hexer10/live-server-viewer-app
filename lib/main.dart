import 'package:sourcemod_liveview/playerlist.dart';
import 'package:flutter/material.dart';

import 'package:sourcemod_liveview/webview.dart';
import 'homepage.dart';
import 'utilis.dart';

Future<void> main() async {
  await loadConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginWebView(),
        '/list': (context) => PlayerList(),
      },
      title: 'Jailbreak Chat',
    );
  }
}
