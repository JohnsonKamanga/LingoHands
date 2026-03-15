import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────
enum DeviceStatus { strongSignal, available, other }

class NearbyDevice {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final DeviceStatus status;
  final String actionLabel;

  const NearbyDevice({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.status,
    required this.actionLabel,
  });
}

const _devices = [
  NearbyDevice(
    name: 'iPhone 13 Pro',
    subtitle: 'Strong Signal',
    icon: Icons.smartphone,
    iconColor: Color(0xFF136DEC),
    iconBgColor: Color(0x33136DEC),
    status: DeviceStatus.strongSignal,
    actionLabel: 'Connect',
  ),
  NearbyDevice(
    name: 'Hearing Loop System',
    subtitle: 'Conference Room B',
    icon: Icons.hearing,
    iconColor: Color(0xFFA88B7D),
    iconBgColor: Color(0x33A88B7D),
    status: DeviceStatus.other,
    actionLabel: 'Connect',
  ),
  NearbyDevice(
    name: 'Pixel Watch',
    subtitle: 'Available',
    icon: Icons.watch,
    iconColor: Color(0xFF9CA3AF),
    iconBgColor: Color(0x26374151),
    status: DeviceStatus.available,
    actionLabel: 'Pair',
  ),
];

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

    _iconScale = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _iconPulse, curve: Curves.easeInOut),
    );
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
                Icon(Icons.signal_cellular_alt, size: 16, color: Color(0xFF9CA3AF)),
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
            style: IconButton.styleFrom(foregroundColor: const Color(0xFF9CA3AF)),
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
          // Glow + image stack
          Stack(
            alignment: Alignment.center,
            children: [
              // Background glow
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
              // Illustration box
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
                      // Placeholder gradient in place of the remote image
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1A2430),
                              Color(0xFF0D1520),
                            ],
                          ),
                        ),
                      ),
                      // Stylised icon placeholder
                      const Center(
                        child: Icon(
                          Icons.connecting_airports,
                          size: 80,
                          color: Color(0x33136DEC),
                        ),
                      ),
                      // Bottom gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xCC101822),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5],
                            ),
                          ),
                        ),
                      ),
                      // Ring overlay
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
          const Text(
            'Link your devices to start real-time\ninclusive translation.',
            textAlign: TextAlign.center,
            style: TextStyle(
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
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 1
              _RippleRing(controller: _ring1),
              // Ring 2 (staggered)
              _RippleRing(controller: _ring2),
              // Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF136DEC),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF136DEC).withOpacity(0.45),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: const Icon(
                        Icons.bluetooth_searching,
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
        const Text(
          'SCANNING...',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF136DEC),
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Looking for nearby devices',
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  // ── Device list ────────────────────────────
  Widget _buildDeviceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
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
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFF136DEC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._devices.map((d) => _DeviceCard(device: d)).toList(),
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
//  Ripple ring widget
// ─────────────────────────────────────────────
class _RippleRing extends StatelessWidget {
  final AnimationController controller;

  const _RippleRing({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value; // 0 → 1
        final size = 80 + 60 * t; // 80 px → 140 px
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

// ─────────────────────────────────────────────
//  Device card
// ─────────────────────────────────────────────
class _DeviceCard extends StatefulWidget {
  final NearbyDevice device;
  const _DeviceCard({required this.device});

  @override
  State<_DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<_DeviceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    final isAvailable = d.status == DeviceStatus.available;
    final isStrong = d.status == DeviceStatus.strongSignal;

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
              color: _hovered
                  ? const Color(0xFF136DEC).withOpacity(0.35)
                  : Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Opacity(
            opacity: isAvailable ? 0.7 : 1.0,
            child: Row(
              children: [
                // Icon circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered ? d.iconColor : d.iconBgColor,
                  ),
                  child: Icon(
                    d.icon,
                    size: 20,
                    color: _hovered ? Colors.white : d.iconColor,
                  ),
                ),
                const SizedBox(width: 14),
                // Name + subtitle
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
                      Row(
                        children: [
                          if (isStrong)
                            Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4ADE80),
                              ),
                            ),
                          Text(
                            d.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: isStrong
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action button
                _ActionButton(
                  label: d.actionLabel,
                  isPrimary: isStrong,
                  isDim: isAvailable,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Action button on each card
// ─────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final bool isDim;

  const _ActionButton({
    required this.label,
    this.isPrimary = false,
    this.isDim = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    final Color bgColor;
    final Color borderColor;

    if (_hovered) {
      textColor = Colors.white;
      bgColor = const Color(0xFF136DEC);
      borderColor = const Color(0xFF136DEC);
    } else if (widget.isPrimary) {
      textColor = const Color(0xFF136DEC);
      bgColor = Colors.white.withOpacity(0.05);
      borderColor = const Color(0xFF136DEC).withOpacity(0.3);
    } else if (widget.isDim) {
      textColor = const Color(0xFF6B7280);
      bgColor = Colors.transparent;
      borderColor = const Color(0xFF374151);
    } else {
      textColor = const Color(0xFFD1D5DB);
      bgColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white.withOpacity(0.1);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}