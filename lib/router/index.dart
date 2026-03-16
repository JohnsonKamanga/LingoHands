import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_hands/components/layout.dart';
import 'package:lingo_hands/screens/connect_devices.dart';
import 'package:lingo_hands/screens/home.dart';
import 'package:lingo_hands/screens/onboarding.dart';
import 'package:lingo_hands/screens/sign_to_text_or_speech.dart';
import 'package:lingo_hands/screens/text_or_speech_to_sign.dart';
import 'package:lingo_hands/view-models/theme_view_model.dart';
import 'package:lingo_hands/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

GoRouter _router(UserViewModel userViewModel) => GoRouter(
  initialLocation: '/',
  refreshListenable: userViewModel,
  redirect: (context, state) async {
    final user = await userViewModel.getCurrentUser();
    final bool onboarding = state.uri.path == '/';

    if (user == null) {
      return onboarding ? null : '/';
    }

    // If logged in and on onboarding screen, redirect to home
    if (onboarding) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sign-to-text',
              builder: (context, state) => const SignTOTextOrSpeechScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/text-to-sign',
              builder: (context, state) => const TextOrSpeechToSignScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/connect-devices',
              builder: (context, state) => const ConnectDevicesScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final GoRouter _routerConfig;

  @override
  void initState() {
    super.initState();
    final userViewModel = context.read<UserViewModel>();
    _routerConfig = _router(userViewModel);
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    return MaterialApp.router(
      routerConfig: _routerConfig,
      themeMode: themeViewModel.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        canvasColor: const Color(0xFFF8FAFC),
        cardColor: const Color(0xFFFFFFFF),
        dividerColor: const Color(0xFFE2E8F0),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF334155),
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Color(0xFF334155),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Color(0xFF0F172A)),
          bodyMedium: TextStyle(color: Color(0xFF334155)),
          bodySmall: TextStyle(color: Color(0xFF64748B)),
          labelLarge: TextStyle(
            color: Color(0xFF334155),
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(color: Color(0xFF64748B)),
          labelSmall: TextStyle(color: Color(0xFF64748B)),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF136DEC),
          onPrimary: Colors.white,
          secondary: Color(0xFF34D399),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF0F172A),
          error: Color(0xFFEF4444),
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFC),
          foregroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF136DEC), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF136DEC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            elevation: 4,
            shadowColor: const Color(0xFF136DEC).withOpacity(0.3),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF136DEC),
          selectionColor: Color(0x33136DEC),
          selectionHandleColor: Color(0xFF136DEC),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101822),
        canvasColor: const Color(0xFF101822),
        cardColor: const Color(0xFF1A2430),
        dividerColor: const Color(0xFF334155),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
          bodySmall: TextStyle(color: Color(0xFF94A3B8)),
          labelLarge: TextStyle(
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(color: Color(0xFF94A3B8)),
          labelSmall: TextStyle(color: Color(0xFF94A3B8)),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF136DEC),
          onPrimary: Colors.white,
          secondary: Color(0xFF34D399),
          onSecondary: Colors.white,
          surface: Color(0xFF1A2430),
          onSurface: Colors.white,
          error: Color(0xFFEF4444),
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101822),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A2430),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF136DEC), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF136DEC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            elevation: 8,
            shadowColor: const Color(0xFF136DEC).withOpacity(0.4),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF136DEC),
          selectionColor: Color(0x33136DEC),
          selectionHandleColor: Color(0xFF136DEC),
        ),
      ),
    );
  }
}
