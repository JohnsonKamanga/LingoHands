import 'package:flutter/material.dart';


// ─────────────────────────────────────────────
//  Wave bar config
// ─────────────────────────────────────────────
const _waveBars = [
  _WaveConfig(baseHeight: 12, duration: 1000, delay: 0),
  _WaveConfig(baseHeight: 24, duration: 1200, delay: 100),
  _WaveConfig(baseHeight: 40, duration: 800, delay: 200),
  _WaveConfig(baseHeight: 20, duration: 1100, delay: 300),
  _WaveConfig(baseHeight: 32, duration: 1300, delay: 100),
  _WaveConfig(baseHeight: 16, duration: 900, delay: 400),
  _WaveConfig(baseHeight: 8, duration: 1000, delay: 200),
];

class _WaveConfig {
  final double baseHeight;
  final int duration;
  final int delay;
  const _WaveConfig(
      {required this.baseHeight, required this.duration, required this.delay});
}

// ─────────────────────────────────────────────
//  Quick reply data
// ─────────────────────────────────────────────
const _quickReplies = [
  '👋 Hello',
  '🙏 Thank you',
  '❓ Help needed',
  '🚆 Transport',
];

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class TextOrSpeechToSignScreen extends StatefulWidget {
  const TextOrSpeechToSignScreen({super.key});

  @override
  State<TextOrSpeechToSignScreen> createState() =>
      _TextOrSpeechToSignScreenState();
}

class _TextOrSpeechToSignScreenState extends State<TextOrSpeechToSignScreen>
    with TickerProviderStateMixin {
  // Green listening dot pulse
  late final AnimationController _dotPulse;

  // Mic button ping
  late final AnimationController _micPing;
  late final Animation<double> _micPingScale;
  late final Animation<double> _micPingOpacity;

  // Wave bar controllers (one per bar)
  late final List<AnimationController> _waveControllers;
  late final List<Animation<double>> _waveAnims;

  @override
  void initState() {
    super.initState();

    // Listening dot
    _dotPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Mic ping
    _micPing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _micPingScale = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _micPing, curve: Curves.easeOut),
    );
    _micPingOpacity = Tween<double>(begin: 0.25, end: 0.0).animate(
      CurvedAnimation(parent: _micPing, curve: Curves.easeOut),
    );

    // Wave bars – staggered start
    _waveControllers = List.generate(_waveBars.length, (i) {
      final cfg = _waveBars[i];
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: cfg.duration),
      );
      // Stagger via delayed repeat
      Future.delayed(Duration(milliseconds: cfg.delay), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      return ctrl;
    });

    _waveAnims = List.generate(_waveBars.length, (i) {
      return Tween<double>(begin: _waveBars[i].baseHeight * 0.2, end: _waveBars[i].baseHeight)
          .animate(CurvedAnimation(
        parent: _waveControllers[i],
        curve: Curves.easeInOut,
      ));
    });
  }

  @override
  void dispose() {
    _dotPulse.dispose();
    _micPing.dispose();
    for (final c in _waveControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x661C1917), // stone-800 ~40%
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main layout
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildAvatarZone()),
                _buildBottomSheet(),
              ],
            ),
          ),

          // Home indicator
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 128,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          _GlassIconButton(icon: Icons.arrow_back, onTap: () {}),

          // "Listening" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing green dot
                AnimatedBuilder(
                  animation: _dotPulse,
                  builder: (_, __) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        const Color(0xFF22C55E),
                        const Color(0xFF86EFAC),
                        _dotPulse.value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const Text(
                  'LISTENING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE2E8F0),
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Settings button
          _GlassIconButton(icon: Icons.settings, onTap: () {}),
        ],
      ),
    );
  }

  // ── Avatar / visual zone ───────────────────
  Widget _buildAvatarZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue spotlight blur
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF136DEC).withOpacity(0.2),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),

          // Avatar card
          AspectRatio(
            aspectRatio: 4 / 5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder gradient (replaces remote image)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E2D40), Color(0xFF0D1520)],
                        ),
                      ),
                    ),
                    // Placeholder icon
                    const Center(
                      child: Icon(
                        Icons.sign_language,
                        size: 72,
                        color: Color(0x33136DEC),
                      ),
                    ),
                    // Border overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                    ),
                    // Sign label pill at bottom
                    Positioned(
                      bottom: 14,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Text(
                            'Sign: "Train Station"',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xE6FFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom sheet ───────────────────────────
  Widget _buildBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A222E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF475569).withOpacity(0.5),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 20),

          // Tags row + volume button
          Row(
            children: [
              // Urgent tag
              _Tag(
                label: 'Urgent',
                icon: Icons.priority_high,
                color: const Color(0xFFF59E0B),
                bgColor: const Color(0x1AF59E0B),
                borderColor: const Color(0x33F59E0B),
              ),
              const SizedBox(width: 8),
              // Language tag
              _Tag(
                label: 'English → ASL',
                color: const Color(0xFF136DEC),
                bgColor: const Color(0x1A136DEC),
                borderColor: const Color(0x33136DEC),
              ),
              const Spacer(),
              // Volume button
              IconButton(
                icon: const Icon(Icons.volume_up),
                color: const Color(0xFF94A3B8),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Translated text
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Can you please help me find the train station?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Audio waveform
          _buildWaveform(),
          const SizedBox(height: 24),

          // Mic button
          Stack(
            alignment: Alignment.center,
            children: [
              // Ping ring
              AnimatedBuilder(
                animation: _micPing,
                builder: (_, __) => Transform.scale(
                  scale: _micPingScale.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF136DEC).withOpacity(
                        _micPingOpacity.value,
                      ),
                    ),
                  ),
                ),
              ),
              // Mic button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF136DEC),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x4D136DEC),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap to Speak',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),

          // Quick replies
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReplies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => _QuickChip(label: _quickReplies[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Waveform visualizer ────────────────────
  Widget _buildWaveform() {
    return SizedBox(
      height: 48,
      child: Opacity(
        opacity: 0.65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_waveBars.length * 2 - 1, (i) {
            if (i.isOdd) return const SizedBox(width: 5);
            final barIdx = i ~/ 2;
            return AnimatedBuilder(
              animation: _waveAnims[barIdx],
              builder: (_, __) {
                return Container(
                  width: 5,
                  height: _waveAnims[barIdx].value,
                  decoration: BoxDecoration(
                    color: const Color(0xFF136DEC),
                    borderRadius: BorderRadius.circular(99),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable glass icon button
// ─────────────────────────────────────────────
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tag pill
// ─────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const _Tag({
    required this.label,
    this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Quick reply chip
// ─────────────────────────────────────────────
class _QuickChip extends StatefulWidget {
  final String label;
  const _QuickChip({required this.label});

  @override
  State<_QuickChip> createState() => _QuickChipState();
}

class _QuickChipState extends State<_QuickChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFF136DEC).withOpacity(0.15)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed
                ? const Color(0xFF136DEC).withOpacity(0.4)
                : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _pressed ? const Color(0xFF136DEC) : const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }
}