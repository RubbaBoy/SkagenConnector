import 'manager.dart';

class TriggerManager implements Manager {

  @override
  String getName() => "trigger";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Trigger manager');
  }

}