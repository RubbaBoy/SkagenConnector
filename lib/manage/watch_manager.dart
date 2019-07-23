// Provide methods

import 'package:skagen_connector/manage/trigger_manager.dart';
import 'package:skagen_connector/pages/home_page.dart';

import 'action_manager.dart';
import 'button_manager.dart';
import 'connect_manager.dart';
import 'io_manager.dart';

class WatchManager {

  IOManager _ioManager;

  ConnectManager connectManager;
  ButtonManager buttonManager;
  TriggerManager triggerManager;
  ActionManager actionManager;

  final HomePageState homePageState;

  WatchManager(this.homePageState);

  Future<void> init() {
    return Future(() async {
      print('Initializing managers...');
      _ioManager = IOManager();
      await _ioManager.init();
      [
        connectManager = ConnectManager(this),
        buttonManager = ButtonManager(this),
        triggerManager = TriggerManager(this),
        actionManager = ActionManager(this)
      ].forEach((manager) => manager.init(_ioManager.getManagerData(manager)));

      print('Initialized Watch manager');
    });
  }

  void dispose() {
    connectManager?.dispose();
  }
}
