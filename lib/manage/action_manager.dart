import 'manager.dart';

class ActionManager implements Manager {

  @override
  String getName() => "action";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Action manager');
  }

}