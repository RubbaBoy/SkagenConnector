import 'manager.dart';
import 'watch_manager.dart';

class ActionManager implements Manager {

  WatchManager _watchManager;

  ActionManager(this._watchManager);

  @override
  String getName() => "action";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Action manager');
  }

}