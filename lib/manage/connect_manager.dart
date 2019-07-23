import 'dart:async';
import 'dart:math';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:skagen_connector/widgets/uadheader.dart';
import 'manager.dart';
import 'watch_manager.dart';

class ConnectManager implements Manager {

  BluetoothDevice attached;
  WatchManager _watchManager;
  UADHManager _uadhManager;
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> _scanSubscription;
  List<BluetoothService> _services;

  void Function(ScanResult result, Set<ScanResult> allResults) onFound;

  ConnectManager(this._watchManager):
        this._uadhManager = _watchManager.homePageState.uadhManager;

  @override
  String getName() => "connect";

  @override
  void init(Map<String, dynamic> json) {
    print('Initialized Connect manager');
  }

  void scanForDevices() {
    if (_scanSubscription != null) return;

    var results = Set<ScanResult>();
    _scanSubscription = _flutterBlue.scan().listen((scanResult) {
      results.add(scanResult);
      if (onFound != null) onFound(scanResult, results);
    });
  }

  Future<List<BluetoothDevice>> getConnected() async {
    return await _flutterBlue.connectedDevices;
  }

  void stopScanning() {
    _scanSubscription?.cancel();
  }

  void dispose() {
    stopScanning();
  }

  void attach(BluetoothDevice device) {
    attached = device;

    _uadhManager.setAttached(device);
    // Yes I know this is bad
    _connect(device).then((_) {
      getBatteryLevel().then((level) {
        print('The battery level is $level');

        print('Trying to set time...');
        setTime(1, 1, Pattern.VERY_LONG);
      });
    });
  }

  void detach() {
    attached = null;

    _uadhManager.detach();
  }

  Future<void> _connect(BluetoothDevice device) {
    return Future.value(() {
      try {device.connect(autoConnect: true);} catch (ignored) {}
    });
  }

  Future<void> refreshServices() {
    return attached?.discoverServices()?.then((services) => _services = services);
  }

  Future<BluetoothCharacteristic> getChar(Service service) async {
    if (_services == null) await refreshServices();
    return _services[service.index].characteristics[0];
  }

  Future<int> getBatteryLevel() => getChar(Service.BATTERY).then((characteristic) => characteristic.read().then((list) => list[0]));


  void setTime(int hour, int min, String pattern) {
    if (Pattern.isValid(pattern)) {
      print('Invalid pattern: $pattern');
      return;
    }

    var initmessage_0_3 = "0207";
    var fixed_4_9 = "0f0a00";
    var vibratingpattern_10_11 = "05";

    var useindicator_12_13 = "05";
    /*
   05 = yes
   everything else no
  */

    var indicatorvariaion_14_15 = "06";
    /*
   06 = use both
   05 = use only minute indicator
   01 = do not use them both
  */

    var onlyvibrate_16_17 = "10";
    /*
   b8 = unknown
   10 = unknown
  */

    var displaytime_18_19 = "27";
    /*
   2b = unknown
   27 = unknown
  */

    var minuteindicator_20_23 = calculateIndicator(min, 'min');
    var hourindicator_24_27 = calculateIndicator(hour, 'hour');
//    if (colour) {
//      minuteindicator_20_23 = calculateColor('black', 'min') ?? minuteindicator_20_23;
//    }

    var toSend = initmessage_0_3
        +fixed_4_9 //seems to be a fixed value.
        +vibratingpattern_10_11
        +useindicator_12_13
        +indicatorvariaion_14_15
        +onlyvibrate_16_17
        +displaytime_18_19
        +minuteindicator_20_23
        +hourindicator_24_27;

    print('toSend: $toSend');

    var sendarray = List<int>();
    for(var i = 0; i < toSend.length - 1; i += 2){
      String subeleemnt = toSend[i] + toSend[i+1];
      sendarray.add(int.parse(subeleemnt, radix: 16));
    }

    print('length: ${sendarray.length}');

    getChar(Service.TIME).then((char) async {
      print('Service ${Service.TIME.index} Dewscriptors: ${char.descriptors.length}');
//      char.write([ 2, 7, 15, 10, 0, 5, 5, 6, 16, 39, 252, 32, 210, 16]);
      print(sendarray);
      await char.write(sendarray);
    });
  }

  String calculateIndicator(int number0To11, String type) {
    number0To11 = max(number0To11, 0);
    number0To11 = min(number0To11, 11);
    number0To11 = number0To11 * 30;
    var direction = type == 'min' ? '20' : '10';

    if (number0To11 > 255) {
      number0To11 -= 256;
      direction = type == 'min' ? '21' : '11';
    }

    var hexString = number0To11.toRadixString(16);
    if(hexString.length == 1) hexString = "0"+hexString;
    return hexString + direction;
  }

}

enum Service {
  UNKNOWN0,
  UNKNOWN1,
  UNKNOWN2,
  BATTERY,
  UNKNOWN4,
  TIME
}

class Pattern {
  static const String VERY_LONG = '08';
  static const String SHORT = '04';
  static const String LONG = '05';
  static const String TWO_LONG = '06';

  static bool isValid(String pattern) => ![VERY_LONG, SHORT, LONG, TWO_LONG].contains(pattern);
}