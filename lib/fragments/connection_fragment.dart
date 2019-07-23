import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:skagen_connector/alert.dart';
import 'package:skagen_connector/manage/connect_manager.dart';
import 'package:skagen_connector/pages/home_page.dart';

class ConnectionFragment extends StatefulWidget {
  final HomePageState homePage;

  ConnectionFragment(this.homePage);

  @override
  State<StatefulWidget> createState() => ConnectionFragmentState();
}

class ConnectionFragmentState extends State<ConnectionFragment> {
  List<BluetoothDevice> devices = [];
  ConnectManager _connectManager;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[
            Text('Connected Devices',
                style: Theme.of(context).textTheme.display1),
            Text('Please select the connected Skagen device'),
            Container(
              height: size.height / 2,
              margin: EdgeInsets.all(32),
              child: ListView.separated(
                padding: const EdgeInsets.all(8.0),
                itemCount: devices.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  var device = devices[index];
                  return new ListTile(
                    title: Text('${device.name} | ${device.id.id}'),
                    onTap: () {
                      _connectManager.attach(device);
                      var deviceName = '${device.name} ';
                      if (deviceName.trim().isEmpty) deviceName = '';
                      alert(
                        context,
                        'Attached to device',
                        content: 'Attached to $deviceName${device.id.id}',
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            RaisedButton(
                child: Text('Refresh'),
                onPressed: refresh
            )
          ],
        ));
  }

  void refresh() {
        _connectManager
        .getConnected()
        .then((connected) => setState(() => devices = connected));
  }

  @override
  void initState() {
    super.initState();
    _connectManager = widget.homePage.watchManager.connectManager;
    refresh();
  }
}
