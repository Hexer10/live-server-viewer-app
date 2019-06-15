import 'package:sourcemod_liveview/playerlist.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:steam_login/steam_login.dart';

=======
import 'package:sourcemod_liveview/webview.dart';
>>>>>>> ec999fd... Update
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
        '/login': (context) => WebviewScaffold(
            url: OpenId.raw('https://azorne.net',
                    'https://azorne.net/script/validate.html', null)
                .authUrl()
                .toString()),
        '/list': (context) => PlayerList(),
      },
      title: 'Jailbreak Chat',
    );
  }
}
