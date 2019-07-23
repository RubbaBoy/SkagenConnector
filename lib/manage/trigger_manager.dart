import 'manager.dart';
import 'watch_manager.dart';

class TriggerManager implements Manager {

  WatchManager _watchManager;

  TriggerManager(this._watchManager);

  @override
  String getName() => "trigger";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Trigger manager');
  }

}