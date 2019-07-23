import 'manager.dart';
import 'watch_manager.dart';

class ButtonManager implements Manager {

  WatchManager _watchManager;

  ButtonManager(this._watchManager);

  @override
  String getName() => "button";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Button manager');
  }

}