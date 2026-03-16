import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:lingo_hands/models/device_connection.dart';
import 'package:lingo_hands/services/connection_service.dart';

class BonsoirConnectionService extends ConnectionService {
  static const String _serviceType = '_lingohands._tcp';
  static const int _port = 4545;

  ConnectionStatus _status = ConnectionStatus.idle;
  final List<DiscoveredDevice> _discoveredDevices = [];
  DiscoveredDevice? _connectedDevice;

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;

  ServerSocket? _serverSocket;
  Socket? _socket;
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  @override
  ConnectionStatus get status => _status;

  @override
  List<DiscoveredDevice> get discoveredDevices =>
      List.unmodifiable(_discoveredDevices);

  @override
  DiscoveredDevice? get connectedDevice => _connectedDevice;

  @override
  Stream<String> get messages => _messageController.stream;

  @override
  Future<void> startBroadcasting(String deviceName) async {
    _status = ConnectionStatus.broadcasting;
    notifyListeners();

    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, _port);
      _serverSocket!.listen(_handleIncomingConnection);

      BonsoirService service = BonsoirService(
        name: deviceName,
        type: _serviceType,
        port: _port,
        attributes: {'ip': 'auto'},
      );

      _broadcast = BonsoirBroadcast(service: service);
      await _broadcast!.ready;
      await _broadcast!.start();
    } catch (e) {
      if (kDebugMode) print('Broadcast error: $e');
      _status = ConnectionStatus.error;
      notifyListeners();
    }
  }

  void _handleIncomingConnection(Socket socket) {
    if (_socket != null) {
      socket.close();
      return;
    }
    _socket = socket;
    _status = ConnectionStatus.connected;
    notifyListeners();

    _socket!.listen(
      (data) {
        String message = utf8.decode(data);
        _messageController.add(message);
      },
      onDone: disconnect,
      onError: (e) => disconnect(),
    );
  }

  @override
  Future<void> stopBroadcasting() async {
    await _broadcast?.stop();
    await _serverSocket?.close();
    _broadcast = null;
    _serverSocket = null;
    _status = ConnectionStatus.idle;
    notifyListeners();
  }

  @override
  Future<void> startDiscovery() async {
    _status = ConnectionStatus.scanning;
    _discoveredDevices.clear();
    notifyListeners();

    try {
      _discovery = BonsoirDiscovery(type: _serviceType);
      await _discovery!.ready;
      _discovery!.eventStream!.listen((event) {
        if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
          event.service!.resolve(_discovery!.serviceResolver);
        } else if (event.type ==
            BonsoirDiscoveryEventType.discoveryServiceResolved) {
          _handleServiceResolved(event.service as ResolvedBonsoirService);
        } else if (event.type ==
            BonsoirDiscoveryEventType.discoveryServiceLost) {
          _handleServiceLost(event.service!);
        }
      });
      await _discovery!.start();
    } catch (e) {
      if (kDebugMode) print('Discovery error: $e');
      _status = ConnectionStatus.error;
      notifyListeners();
    }
  }

  void _handleServiceResolved(ResolvedBonsoirService service) {
    var device = DiscoveredDevice(
      id: service.name,
      name: service.name,
      ip: service.ip,
      port: service.port,
      attributes: service.attributes,
    );
    _discoveredDevices.removeWhere((d) => d.id == device.id);
    _discoveredDevices.add(device);
    notifyListeners();
  }

  void _handleServiceLost(BonsoirService service) {
    _discoveredDevices.removeWhere((d) => d.id == service.name);
    notifyListeners();
  }

  @override
  Future<void> stopDiscovery() async {
    await _discovery?.stop();
    _discovery = null;
    _status = ConnectionStatus.idle;
    notifyListeners();
  }

  @override
  Future<void> connect(DiscoveredDevice device) async {
    _status = ConnectionStatus.connecting;
    notifyListeners();

    try {
      _socket = await Socket.connect(device.ip, device.port ?? _port);
      _connectedDevice = device;
      _status = ConnectionStatus.connected;
      notifyListeners();

      _socket!.listen(
        (data) {
          String message = utf8.decode(data);
          _messageController.add(message);
        },
        onDone: disconnect,
        onError: (e) => disconnect(),
      );
    } catch (e) {
      if (kDebugMode) print('Connect error: $e');
      _status = ConnectionStatus.error;
      notifyListeners();
    }
  }

  @override
  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
    _connectedDevice = null;
    _status = ConnectionStatus.idle;
    notifyListeners();
  }

  @override
  Future<void> sendMessage(String message) async {
    if (_socket != null) {
      _socket!.add(utf8.encode(message));
      await _socket!.flush();
    }
  }

  @override
  void dispose() {
    stopBroadcasting();
    stopDiscovery();
    disconnect();
    _messageController.close();
    super.dispose();
  }
}
