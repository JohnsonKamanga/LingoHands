import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Quick-reply chip data
// ─────────────────────────────────────────────
const _quickReplies = [
  '👋 Hello there!',
  '👍 Sounds good',
  '❓ Can you repeat?',
  'Thank you',
];

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class SignTOTextOrSpeechScreen extends StatefulWidget {
  const SignTOTextOrSpeechScreen({super.key});

  @override
  State<SignTOTextOrSpeechScreen> createState() => _SignTOTextOrSpeechScreenState();
}

class _SignTOTextOrSpeechScreenState extends State<SignTOTextOrSpeechScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  // Green-dot pulse (connection indicator)
  late final AnimationController _dotPulse;

  // Switch-turn button ping
  late final AnimationController _switchPing;
  late final Animation<double> _switchPingScale;
  late final Animation<double> _switchPingOpacity;

  // Sentiment icon bounce
  late final AnimationController _bounce;
  late final Animation<double> _bounceOffset;

  @override
  void initState() {
    super.initState();

    _dotPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _switchPing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _switchPingScale = Tween<double>(begin: 1.0, end: 1.7).animate(
      CurvedAnimation(parent: _switchPing, curve: Curves.easeOut),
    );
    _switchPingOpacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(parent: _switchPing, curve: Curves.easeOut),
    );

    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _bounceOffset = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _bounce, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _dotPulse.dispose();
    _switchPing.dispose();
    _bounce.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // Top pane – deaf user / camera
                        Expanded(child: _buildCameraPane()),
                        const SizedBox(height: 8),
                        // Bottom pane – hearing user / input
                        Expanded(child: _buildInputPane()),
                      ],
                    ),
                    // Centre switch button
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildSwitchButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color(0xFF94A3B8),
            onPressed: () {},
          ),
          // Title + status
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Alex M.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
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
                    const SizedBox(width: 5),
                    const Text(
                      'CONNECTED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            color: const Color(0xFF94A3B8),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ── Camera / deaf-user pane ────────────────
  Widget _buildCameraPane() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF4ADE80).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ADE80).withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Simulated camera feed background
            Container(color: const Color(0xFF1E293B)),
            // Bottom gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xCC000000), Colors.transparent],
                    stops: [0.0, 0.55],
                  ),
                ),
              ),
            ),
            // "Signing detected" badge (top-left)
            Positioned(
              top: 14,
              left: 14,
              child: _GlassBadge(
                icon: Icons.videocam,
                iconColor: const Color(0xFF4ADE80),
                label: 'Signing detected',
              ),
            ),
            // Translation bubble + sentiment icon (bottom)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Translation bubble
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Text(
                            'Hello! It is so nice to finally meet you.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Bouncing sentiment icon
                      AnimatedBuilder(
                        animation: _bounce,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _bounceOffset.value),
                          child: child,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFACC15).withOpacity(0.2),
                            border: Border.all(
                              color: const Color(0xFFFACC15).withOpacity(0.35),
                            ),
                          ),
                          child: const Icon(
                            Icons.sentiment_satisfied_alt,
                            color: Color(0xFFFACC15),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'Translating live...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Switch-turn centre button ──────────────
  Widget _buildSwitchButton() {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ping ring
            AnimatedBuilder(
              animation: _switchPing,
              builder: (_, __) => Transform.scale(
                scale: _switchPingScale.value,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF136DEC).withOpacity(
                      _switchPingOpacity.value,
                    ),
                  ),
                ),
              ),
            ),
            // Outer ring (dark border)
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF101822),
                border: Border.all(
                  color: const Color(0xFF101822),
                  width: 4,
                ),
              ),
            ),
            // Inner blue circle
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF136DEC),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80136DEC),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sync_alt,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hearing-user / input pane ──────────────
  Widget _buildInputPane() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF1E293B), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'YOUR TURN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF136DEC),
                      letterSpacing: 1.4,
                    ),
                  ),
                  Icon(
                    Icons.graphic_eq,
                    color: Color(0xFF334155),
                    size: 22,
                  ),
                ],
              ),
            ),
            // Placeholder text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Tap to type or hold mic to speak...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF475569).withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            // Quick reply chips
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickReplies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _QuickReplyChip(label: _quickReplies[i]),
              ),
            ),
            const SizedBox(height: 8),
            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.8),
                border: const Border(
                  top: BorderSide(color: Color(0xFF1E293B), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 15,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.keyboard,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Mic button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF136DEC),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4D3B82F6),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Glass badge (top of camera pane)
// ─────────────────────────────────────────────
class _GlassBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _GlassBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Quick reply chip
// ─────────────────────────────────────────────
class _QuickReplyChip extends StatefulWidget {
  final String label;
  const _QuickReplyChip({required this.label});

  @override
  State<_QuickReplyChip> createState() => _QuickReplyChipState();
}

class _QuickReplyChipState extends State<_QuickReplyChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFF136DEC).withOpacity(0.2)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: _pressed
                ? const Color(0xFF136DEC).withOpacity(0.4)
                : Colors.transparent,
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