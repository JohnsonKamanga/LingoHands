import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lingo_hands/models/device_connection.dart';
import 'package:lingo_hands/services/connection_service.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class ConnectDevicesScreen extends StatefulWidget {
  const ConnectDevicesScreen({super.key});

  @override
  State<ConnectDevicesScreen> createState() => _ConnectDevicesScreenState();
}

class _ConnectDevicesScreenState extends State<ConnectDevicesScreen>
    with TickerProviderStateMixin {
  // Ripple rings: two staggered controllers
  late final AnimationController _ring1;
  late final AnimationController _ring2;
  // Icon scale pulse
  late final AnimationController _iconPulse;
  late final Animation<double> _iconScale;

  bool _isCreatorMode = false;

  @override
  void initState() {
    super.initState();

    _ring1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _ring2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward(from: 0.3); // 600 ms offset ≈ 0.3 of 2 s
    _ring2.addStatusListener((s) {
      if (s == AnimationStatus.completed) _ring2.repeat();
    });

    _iconPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _iconScale = Tween<double>(
      begin: 0.88,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _iconPulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    _iconPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildStatusBar(),
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 428),
                  child: Column(
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 8),
                      _buildModeSelector(),
                      const SizedBox(height: 24),
                      _buildScanButton(),
                      const SizedBox(height: 36),
                      _buildDeviceList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF101822),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Look for Connections',
              isSelected: !_isCreatorMode,
              onTap: () => setState(() => _isCreatorMode = false),
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: 'Create Connection',
              isSelected: _isCreatorMode,
              onTap: () => setState(() => _isCreatorMode = true),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status bar mock ────────────────────────
  Widget _buildStatusBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '9:41',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9CA3AF),
              ),
            ),
            Row(
              children: const [
                Icon(
                  Icons.signal_cellular_alt,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
                SizedBox(width: 4),
                Icon(Icons.wifi, size: 16, color: Color(0xFF9CA3AF)),
                SizedBox(width: 4),
                Icon(Icons.battery_full, size: 16, color: Color(0xFF9CA3AF)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF101822).withOpacity(0.9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Connect Devices',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero illustration ──────────────────────
  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF136DEC).withOpacity(0.15),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF136DEC).withOpacity(0.2),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1A2430), Color(0xFF0D1520)],
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.connecting_airports,
                          size: 80,
                          color: Color(0x33136DEC),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color(0xCC101822), Colors.transparent],
                              stops: [0.0, 0.5],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Bridge the Gap',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isCreatorMode
                ? 'Allow other devices to find and connect\nto this device.'
                : 'Link your devices to start real-time\ninclusive translation.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Scan button with ripple rings ──────────
  Widget _buildScanButton() {
    final service = context.watch<ConnectionService>();
    final isRunning =
        service.status == ConnectionStatus.scanning ||
        service.status == ConnectionStatus.broadcasting;

    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isRunning) ...[
                _RippleRing(controller: _ring1),
                _RippleRing(controller: _ring2),
              ],
              GestureDetector(
                onTap: () {
                  if (isRunning) {
                    if (_isCreatorMode) {
                      service.stopBroadcasting();
                    } else {
                      service.stopDiscovery();
                    }
                  } else {
                    if (_isCreatorMode) {
                      service.startBroadcasting('LingoHands Device');
                    } else {
                      service.startDiscovery();
                    }
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRunning
                        ? const Color(0xFF136DEC)
                        : const Color(0xFF101822),
                    boxShadow: [
                      if (isRunning)
                        BoxShadow(
                          color: const Color(0xFF136DEC).withOpacity(0.45),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                    ],
                    border: Border.all(
                      color: isRunning
                          ? Colors.transparent
                          : const Color(0xFF136DEC).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: Icon(
                        _isCreatorMode
                            ? Icons.cell_tower
                            : Icons.bluetooth_searching,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          isRunning
              ? (_isCreatorMode ? 'BROADCASTING...' : 'SCANNING...')
              : 'READY TO CONNECT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isRunning
                ? const Color(0xFF136DEC)
                : const Color(0xFF9CA3AF),
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isRunning
              ? (_isCreatorMode
                    ? 'Visible to nearby devices'
                    : 'Looking for nearby devices')
              : 'Tap the button to start',
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  // ── Device list ────────────────────────────
  Widget _buildDeviceList() {
    final service = context.watch<ConnectionService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'NEARBY DEVICES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD1D5DB),
                letterSpacing: 1.2,
              ),
            ),
            if (service.status == ConnectionStatus.scanning ||
                service.status == ConnectionStatus.broadcasting)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF136DEC),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (!_isCreatorMode) ...[
          if (service.discoveredDevices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No devices found yet',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              ),
            )
          else
            ...service.discoveredDevices.map(
              (d) => _DiscoveredDeviceCard(
                device: d,
                onConnect: () => service.connect(d),
                isConnected: service.connectedDevice?.id == d.id,
              ),
            ),
        ] else ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Waiting for connections...',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              ),
            ),
          ),
          if (service.status == ConnectionStatus.connected)
            const Center(
              child: Text(
                'A device has connected!',
                style: TextStyle(
                  color: Color(0xFF4ADE80),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Make sure the device you want to connect\nto is in pairing mode.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom bar ─────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      height: 4,
      color: const Color(0x80374151),
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 1 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF136DEC),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Helper Widgets
// ─────────────────────────────────────────────

class _RippleRing extends StatelessWidget {
  final AnimationController controller;

  const _RippleRing({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final size = 80 + 60 * t;
        final opacity = (1.0 - t) * 0.7;
        final borderWidth = math.max(0.0, 4.0 * (1 - t));

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF136DEC).withOpacity(opacity),
              width: borderWidth,
            ),
          ),
        );
      },
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF136DEC) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}

class _DiscoveredDeviceCard extends StatefulWidget {
  final DiscoveredDevice device;
  final VoidCallback onConnect;
  final bool isConnected;

  const _DiscoveredDeviceCard({
    required this.device,
    required this.onConnect,
    required this.isConnected,
  });

  @override
  State<_DiscoveredDeviceCard> createState() => _DiscoveredDeviceCardState();
}

class _DiscoveredDeviceCardState extends State<_DiscoveredDeviceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.device;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFF101822).withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered || widget.isConnected
                  ? const Color(0xFF136DEC).withOpacity(0.35)
                  : Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF136DEC).withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.smartphone,
                  size: 20,
                  color: Color(0xFF136DEC),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.isConnected
                          ? 'Connected'
                          : (d.ip ?? 'Resolving...'),
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.isConnected
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              _ActionButton(
                label: widget.isConnected ? 'Disconnect' : 'Connect',
                isPrimary: !widget.isConnected,
                onTap: widget.onConnect,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF136DEC)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF136DEC)
                  : const Color(0xFF136DEC).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _hovered ? Colors.white : const Color(0xFF136DEC),
            ),
          ),
        ),
      ),
    );
  }
}
