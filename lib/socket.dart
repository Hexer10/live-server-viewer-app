import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sourcemod_liveview/player.dart';
import 'package:sourcemod_liveview/utilis.dart';

import 'chatmessage.dart';

// ignore: avoid_classes_with_only_static_members
class ServerSocket {
  static final ServerSocket _singleton = ServerSocket._internal();

  factory ServerSocket() => _singleton;

  ServerSocket._internal();

  Socket _socket;

  Socket get socket => _socket;

  static final _key = apikey;

  bool _ignore = false;

  StreamController<ChatMessage> _onChatMessage =
      StreamController<ChatMessage>.broadcast(); // 0

  StreamController<Map<String, dynamic>> _onUpdateInfo =
      StreamController<Map<String, dynamic>>.broadcast(); // 1

  StreamController<String> _onUpdateMap =
      StreamController<String>.broadcast(); // 2

  StreamController<bool> _onUpdatePlayerCount =
      StreamController<bool>.broadcast(); // 3 True if joined, false if quitted

  StreamController<Player> _onUpdatePlayer =
      StreamController<Player>.broadcast(); // 4

  StreamController<Player> _onPlayerJoin =
      StreamController<Player>.broadcast(); // 5

  StreamController<int> _onPlayerQuit = StreamController<int>.broadcast(); // 3

  StreamController<List<dynamic>> _onPlayerChangeTeam =
      StreamController<List<dynamic>>.broadcast(); //6

  StreamController<List<dynamic>> _onPlayerChangeAliveStatus =
      StreamController<List<dynamic>>.broadcast(); // 7

  StreamController<void> _onConnection = StreamController<void>.broadcast();

  StreamController<void> _onConnectionClose =
      StreamController<void>.broadcast();

  Stream<ChatMessage> get onChatMessage => _onChatMessage.stream;

  Stream<Map<String, dynamic>> get onUpdateInfo => _onUpdateInfo.stream;

  Stream<String> get onUpdateMap => _onUpdateMap.stream;

  Stream<bool> get onUpdatePlayerCount => _onUpdatePlayerCount.stream;

  Stream<Player> get onUpdatePlayer => _onUpdatePlayer.stream;

  Stream<Player> get onPlayerJoin => _onPlayerJoin.stream;

  Stream<int> get onPlayerQuit => _onPlayerQuit.stream;

  Stream<List<dynamic>> get onPlayerChangeTeam => _onPlayerChangeTeam.stream;

  Stream<List<dynamic>> get onPlayerChangeAliveStatus =>
      _onPlayerChangeAliveStatus.stream;

  Stream<void> get onConnection => _onConnection.stream;

  Stream<void> get onConnectionClose => _onConnectionClose.stream;

  String _hostname;
  String _map;
  int _maxSlot;
  int _currentSlot;

  // Used to cache icons
  Map<int, String> _icons = <int, String>{};

  String get hostname => _hostname;

  String get map => _map;

  int get maxSlot => _maxSlot;

  int get currentSlot => _currentSlot;

  Future<void> initSocket() async {
<<<<<<< HEAD
    _socket = await Socket.connect('csgo.azorne.net', 50001);
=======
    if (_socket != null) {
      //We dont want 2 open sockets
      _socket.destroy();
    }

    _socket = await Socket.connect(serverIP, serverPort);
>>>>>>> ec999fd... Update
    _socket.transform(utf8.decoder).listen(_handlePackets, onDone: () {
      if (_ignore) {
        _ignore = false;
        return;
      }

      _onConnectionClose.add(null);
    });
    if (_ignore) {
      return;
    }
    // ignore: avoid_catches_without_on_clauses
  }

  Future<void> reloadSocket() async {
    if (_socket == null) {
      return;
    }

    _ignore = true;
    try {
      await _socket.close();
<<<<<<< HEAD
    } finally {
=======
    } on SocketException {} finally {
>>>>>>> ec999fd... Update
      await initSocket();
    }
  }

  Future<void> _handlePackets(String rawData) async {
    var index = rawData.indexOf('}{"');
    if (index != -1) {
      _handlePackets(rawData.substring(index + 1));
      rawData = rawData.substring(0, index+1);
    }


    Map<String, dynamic> data;
    try {
      data = json.decode(rawData);
    } on FormatException {
      print('Failed to parse json: $rawData');
      return;
    }
    print(data);

    // Chat Messages
    if (data['type'] == 0) {
      var message = ChatMessage(
          name: data['name'],
          text: data['message'],
          icon: await _getIcon(data),
          steamid: data['steamid']);

      _onChatMessage.add(message);
    } else if (data['type'] == 1) {
      //Full info update
      _hostname = data['hostname'];
      _map = data['map'];
      _maxSlot = data['maxslot'];
      _currentSlot = data['currentSlot'];

      _onUpdateInfo.add({
        'hostname': hostname,
        'map': map,
        'maxslot': maxSlot,
        'current': currentSlot
      });
    } else if (data['type'] == 2) {
      _map = data['map'];
      _onUpdateMap.add(_map);
    } else if (data['type'] == 3) {
      var join = data['connect'];
      _currentSlot += join ? 1 : -1;
      _onUpdatePlayerCount.add(data['connect']);
      if (!join) {
        _icons.remove(_icons[data['userid']]);
        _onPlayerQuit.add(data['userid']);
      }

      print('Slots $_currentSlot');
    } else if (data['type'] == 4) {
      for (Map map in data['players']) {
        map['icon'] = await _getIcon(map);
        _onUpdatePlayer.add(Player.fromMap(map));
      }
    } else if (data['type'] == 5) {
      print('SID: ${data['steamid']}');
      data['icon'] = await _getIcon(data);
      _onPlayerJoin.add(Player.fromMap(data));
    } else if (data['type'] == 6) {
      _onPlayerChangeTeam.add([data['userid'], data['team']]);
    } else if (data['type'] == 7) {
      _onPlayerChangeAliveStatus.add([data['userid'], data['alive']]);
    }
  }

  Future<String> _getIcon(var data) async {
    int userid = data['userid'];

    if (!_icons.containsKey(userid)) {
      print('SID: ${data['steamid']}');
      var response = await http.get(
          'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$_key&steamids=${data['steamid']}');

      //Failed to get the key
      if (response.statusCode != 200) {
        return 'http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png';
      }

      var info = jsonDecode(response.body);
      print(info);
      _icons[userid] = info['response']['players'][0]['avatarfull'];
    }
    return _icons[userid];
  }

  void write(packet) => socket.write(packet);
}
