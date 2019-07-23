import 'package:skagen_connector/fragments/connection_fragment.dart';
import 'package:skagen_connector/fragments/first_fragment.dart';
import 'package:skagen_connector/fragments/second_fragment.dart';
import 'package:skagen_connector/fragments/third_fragment.dart';
import 'package:flutter/material.dart';
import 'package:skagen_connector/manage/watch_manager.dart';
import 'package:skagen_connector/widgets/uadheader.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Connection", Icons.settings_bluetooth),
    new DrawerItem("Button Mapping", Icons.watch),
    new DrawerItem("Triggers", Icons.event),
    new DrawerItem("Actions", Icons.add_alarm)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  WatchManager watchManager;
  bool loading = true;
  UADHeader uadHeader = UADHeader();

  _getDrawerItemWidget(int pos) {
    return [ConnectionFragment(this), SecondFragment(), ThirdFragment(), ThirdFragment(), new Text('Error')][pos];
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: loading ? null :
      new Drawer(
        child: new Column(
          children: <Widget>[
            uadHeader,
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  @override
  void initState() {
    super.initState();
    watchManager = WatchManager(this);
    watchManager.init().whenComplete(() {
      print('Finished initting! Removing loading icon!');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    watchManager.dispose();
  }

}
