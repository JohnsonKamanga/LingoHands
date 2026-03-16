enum ConnectionStatus {
  idle,
  broadcasting,
  scanning,
  connecting,
  connected,
  disconnected,
  error,
}

class DiscoveredDevice {
  final String id;
  final String name;
  final String? ip;
  final int? port;
  final Map<String, String>? attributes;

  DiscoveredDevice({
    required this.id,
    required this.name,
    this.ip,
    this.port,
    this.attributes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveredDevice &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
