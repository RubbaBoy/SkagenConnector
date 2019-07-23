import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:skagen_connector/manage/connect_manager.dart';

class UADHManager {
  String name;
  String mac;

  void setAttached(BluetoothDevice device) {
    name = device.name;
    mac = device.id.id;
  }

  void detach() {
    name = null;
    mac = null;
  }
}

class UADHeader extends StatefulWidget {

  final UADHManager uadhManager;

  UADHeader(this.uadhManager);

  @override
  State createState() => UADHeaderState(uadhManager);
}

class UADHeaderState extends State<UADHeader> {

  UADHManager _uadhManager;

  UADHeaderState(this._uadhManager);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text(_uadhManager.name ?? 'Disconnected'),
        accountEmail: Text(_uadhManager.mac ?? ''),
    );
  }
}