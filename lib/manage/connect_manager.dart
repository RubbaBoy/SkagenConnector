import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

import 'manager.dart';

class ConnectManager implements Manager {

  BluetoothDevice attached;
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> _scanSubscription;
  void Function(ScanResult result, Set<ScanResult> allResults) onFound;

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
  }

}