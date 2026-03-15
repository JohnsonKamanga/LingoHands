import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_hands/screens/onboarding.dart';
import 'package:lingo_hands/view-models/theme_view_model.dart';
import 'package:lingo_hands/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

GoRouter _router(UserViewModel userViewModel) => GoRouter(
  initialLocation: '/',
  refreshListenable: userViewModel,
  redirect: (context, state) async {
    final user = await userViewModel.getCurrentUser();
    if (user == null) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
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
        primaryColor: const Color(0xFF136DEC),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF1E293B)),
        ),
        cardColor: const Color(0xFFFFFFFF),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF136DEC),
          surface: Colors.white,
          secondary: Color(0xFF34D399),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF136DEC),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101822),
        canvasColor: const Color(0xFF101822),
        cardColor: const Color(0xFF1A2430),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFCBD5E1)),
          bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF136DEC),
          surface: Color(0xFF101822),
          secondary: Color(0xFF34D399),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2430),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF136DEC),
        ),
      ),
    );
  }
}
