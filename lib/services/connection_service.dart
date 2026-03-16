import 'package:lingo_hands/models/device_connection.dart';
import 'package:flutter/foundation.dart';

abstract class ConnectionService extends ChangeNotifier {
  ConnectionStatus get status;
  List<DiscoveredDevice> get discoveredDevices;
  DiscoveredDevice? get connectedDevice;

  Future<void> startBroadcasting(String deviceName);
  Future<void> stopBroadcasting();

  Future<void> startDiscovery();
  Future<void> stopDiscovery();

  Future<void> connect(DiscoveredDevice device);
  Future<void> disconnect();

  Future<void> sendMessage(String message);
  Stream<String> get messages;
}
