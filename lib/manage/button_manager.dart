import 'manager.dart';

class ButtonManager implements Manager {

  @override
  String getName() => "button";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Button manager');
  }

}