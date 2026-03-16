import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Data
// ─────────────────────────────────────────────
class _Conversation {
  final String name;
  final String preview;
  final String time;
  final Color avatarColor;
  final String initials;

  const _Conversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.avatarColor,
    required this.initials,
  });
}

const _conversations = [
  _Conversation(
    name: 'Elias Thorne',
    preview: '"Thank you for your help today..."',
    time: '2m ago',
    avatarColor: Color(0xFF1D4ED8),
    initials: 'ET',
  ),
  _Conversation(
    name: 'Sarah Miller',
    preview: '"Where is the community center?"',
    time: '1h ago',
    avatarColor: Color(0xFF0F766E),
    initials: 'SM',
  ),
];

// ─────────────────────────────────────────────
//  Home Screen
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dot-grid background pattern
        Positioned.fill(child: _DotGridBackground()),

        Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  _buildStartButton(),
                  _buildRecentConversations(),
                  _buildDailyInspiration(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── App bar ────────────────────────────────
  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          border: const Border(
            bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Logo icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF136DEC).withOpacity(0.2),
              ),
              child: const Icon(
                Icons.diversity_3,
                color: Color(0xFF136DEC),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'LingoHands',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: const Color(0xFF94A3B8),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ── Start conversation button ──────────────
  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: _PressableButton(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF136DEC),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF136DEC).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_comment, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Start New Conversation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Recent conversations ───────────────────
  Widget _buildRecentConversations() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Conversations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF136DEC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(
            _conversations.length,
            (i) => Padding(
              padding: EdgeInsets.only(
                bottom: i < _conversations.length - 1 ? 10 : 0,
              ),
              child: _ConversationCard(conversation: _conversations[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Daily inspiration ──────────────────────
  Widget _buildDailyInspiration() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x1A136DEC), Color(0x1A2DD4BF)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF136DEC).withOpacity(0.2)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Large quote icon watermark
            Positioned(
              top: -10,
              right: -6,
              child: Icon(
                Icons.format_quote,
                size: 56,
                color: const Color(0xFF136DEC).withOpacity(0.18),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DAILY INSPIRATION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF136DEC),
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '"The most important thing in communication is hearing what isn\'t being said."',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFE2E8F0),
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '— Peter Drucker',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Dot grid background
// ─────────────────────────────────────────────
class _DotGridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotGridPainter());
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF136DEC).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    const radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  Conversation card
// ─────────────────────────────────────────────
class _ConversationCard extends StatefulWidget {
  final _Conversation conversation;
  const _ConversationCard({required this.conversation});

  @override
  State<_ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<_ConversationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.conversation;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF136DEC).withOpacity(0.5)
                  : const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar circle with initials
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.avatarColor.withOpacity(0.8),
                ),
                child: Center(
                  child: Text(
                    c.initials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Name + preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      c.preview,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Timestamp
              Text(
                c.time,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Pressable scale button wrapper
// ─────────────────────────────────────────────
class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableButton({required this.child, required this.onTap});

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
