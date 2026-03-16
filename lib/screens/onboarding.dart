import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_hands/models/user.dart';
import 'package:lingo_hands/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────
//  Data model for a role card
// ─────────────────────────────────────────────
class RoleOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const RoleOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────────
//  Main Onboarding Screen
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Name controller
  final TextEditingController _nameController = TextEditingController();

  // Selected sign language index in the dropdown
  String _selectedLanguage = 'American Sign Language (ASL)';

  // Which role card is selected (-1 = none)
  int _selectedRole = -1;

  final List<String> _languages = [
    'American Sign Language (ASL)',
    'British Sign Language (BSL)',
    'French Sign Language (LSF)',
    'Japanese Sign Language (JSL)',
  ];

  final List<RoleOption> _roles = const [
    RoleOption(
      title: 'I am Deaf / Hard-of-Hearing',
      subtitle: 'Translate sign to text & speech',
      icon: Icons.hearing_disabled,
      iconBgColor: Color(0x33818CF8), // indigo tint
      iconColor: Color(0xFF136DEC),
    ),
    RoleOption(
      title: 'I am Hearing',
      subtitle: 'Translate speech to text & avatars',
      icon: Icons.record_voice_over,
      iconBgColor: Color(0x3334D399), // emerald tint
      iconColor: Color(0xFF34D399),
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient overlay (sage tint)
          _buildBackground(),

          // Scrollable content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildHeader(),
                          const SizedBox(height: 40),
                          _buildNameInput(),
                          const SizedBox(height: 28),
                          _buildLanguageSelector(),
                          const SizedBox(height: 28),
                          _buildRoleSection(),
                          const Spacer(),
                          const SizedBox(height: 32),
                          _buildPrivacyBadge(),
                          const SizedBox(height: 20),
                          _buildGetStartedButton(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ─────────────────────────────
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF101822),
            Color(0xFF10182D), // very subtle blue tint at bottom
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo icon container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0x1A136DEC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x33136DEC), width: 1),
          ),
          child: const Icon(
            Icons.sign_language,
            color: Color(0xFF136DEC),
            size: 44,
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(text: 'Welcome to '),
              TextSpan(
                text: 'LingoHands',
                style: TextStyle(color: Color(0xFF136DEC)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bridging Silence with Digital Touch',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Name Input ─────────────────────────────
  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'What is your name?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A2430),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF334155), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Language Selector ──────────────────────
  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Select Sign Language Standard',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A2430),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF334155), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A2430),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              icon: const Icon(Icons.expand_more, color: Color(0xFF94A3B8)),
              padding: const EdgeInsets.only(
                left: 12,
                right: 8,
                top: 4,
                bottom: 4,
              ),
              borderRadius: BorderRadius.circular(14),
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Color(0xFF136DEC),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(lang, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedLanguage = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Role Section ───────────────────────────
  Widget _buildRoleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Identify your role to customize experience',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(
          _roles.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i < _roles.length - 1 ? 12 : 0),
            child: _buildRoleCard(i),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard(int index) {
    final role = _roles[index];
    final isSelected = _selectedRole == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF136DEC).withOpacity(0.08)
              : const Color(0xFF1A2430),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF136DEC)
                : const Color(0xFF334155),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: role.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(role.icon, color: role.iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF136DEC)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    role.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Radio icon
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? const Color(0xFF136DEC)
                  : const Color(0xFF475569),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── Privacy Badge ──────────────────────────
  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.security, color: Color(0xFF34D399), size: 16),
          SizedBox(width: 6),
          Text(
            'Offline Encryption & Privacy First',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  // ── Get Started Button ─────────────────────
  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_nameController.text.trim().isEmpty || _selectedRole == -1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter your name and select a role.'),
              ),
            );
            return;
          }

          final userViewModel = context.read<UserViewModel>();
          final role = _selectedRole == 0 ? Role.deaf : Role.hearing;
          final signLanguageType = SignLanguageType
              .asl; // Currently only ASL is strictly typed in enum

          final user = User(
            name: _nameController.text.trim(),
            role: role,
            signLanguageType: signLanguageType,
          );

          await userViewModel.setCurrentUser(user);

          if (mounted) {
            context.go('/home');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}
