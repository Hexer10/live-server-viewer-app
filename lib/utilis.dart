import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

StreamController<String> _onSteamIDUpdate =
    StreamController<String>.broadcast(onListen: () async {
  var prefs = await SharedPreferences.getInstance();
  _onSteamIDUpdate.add(prefs.getString('steamid'));
});

String _url;
String _validatePath;
String _serverIP;
int _serverPort;
String _apikey;


/// Add the steamid to the stream and update the
/// shared prefs value. If [steamid] is null or empty the key will be removed.
Future<void> addSteamID(String steamid) async {
  print('******************* ADDED STEAMID $steamid ******************');
  _onSteamIDUpdate.add(steamid);
  var prefs = await SharedPreferences.getInstance();

  if (steamid == null || steamid.trim().isEmpty) {
    await prefs.remove('steamid');
    return;
  }
  await prefs.setString('steamid', steamid);
}

Future<void> loadConfig() async {
  var config = loadYaml(await rootBundle.loadString('assets/config.yaml'))['config'];
  print(config);
  _url = config['web']['url'];
  _validatePath = config['web']['validate'];
  _serverIP = config['server']['ip'];
  _serverPort = int.parse(config['server']['port']);
  _apikey = config['steam']['apikey'];
}

Stream<String> get onSteamIDUpdate => _onSteamIDUpdate.stream;

String get url => _url;
String get validatePath => _validatePath;
String get serverIP => _serverIP;
int get serverPort => _serverPort;
String get apikey => _apikey;
