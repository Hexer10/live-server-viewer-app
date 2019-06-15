import 'package:flutter/material.dart';
import 'package:steam_login/steam_login.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'utilis.dart';

class LoginWebView extends StatefulWidget {
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {

  static final _validate = '$url/$validatePath';
  static final _loadUrl = OpenId.raw(
          url, _validate, null)
      .authUrl()
      .toString();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login!')),
        body: WebView(
          initialUrl: _loadUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (delegate) {
            final url = delegate.url;

            if (!url.startsWith(_validate))
              return NavigationDecision.navigate;

            final openid = OpenId.fromUri(Uri.parse(url));
            if (openid.mode == 'id_res') {
              print('Closing...');


              openid.validate().then((steamid) async {
                await addSteamID(steamid);
                Navigator.pop(context);
              });
            }
            // TODO(Hexah): Implement other openid modes.
            return NavigationDecision.navigate;
          },
        ));
  }
}