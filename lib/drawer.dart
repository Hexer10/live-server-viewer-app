import 'package:flutter/material.dart';

import 'socket.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  ServerSocket socket = ServerSocket();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(socket.hostname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(''),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                    TextSpan(text: 'Current map:'),
                    TextSpan(
                        text: socket.map,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent)),
                  ])),
              Text(''),
              Text('Slots: ${socket.currentSlot}/${socket.maxSlot}'),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        /*ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.popAndPushNamed(context, '/');
          },
        ),*/
      ],
    ));
  }
}
