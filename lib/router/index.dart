import 'package:go_router/go_router.dart';
import 'package:lingo_hands/screens/onboarding.dart';
import 'package:lingo_hands/view-models/user_view_model.dart';

GoRouter router(UserViewModel userViewModel) => GoRouter(
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
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);