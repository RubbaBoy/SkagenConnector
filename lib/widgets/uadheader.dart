import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UADHeader extends StatefulWidget {

  @override
  State createState() => UADHeaderState();
}

class UADHeaderState extends State<UADHeader> {

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text('Disconnected'),
        accountEmail: Text('Email here'),
    );
  }
}