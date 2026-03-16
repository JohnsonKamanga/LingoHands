import 'package:flutter/material.dart';
import 'package:lingo_hands/router/index.dart' as app_router;
import 'package:lingo_hands/services/user_services.dart';
import 'package:lingo_hands/services/bonsoir_connection_service.dart';
import 'package:lingo_hands/services/connection_service.dart';
import 'package:lingo_hands/view-models/theme_view_model.dart';
import 'package:lingo_hands/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => UserServices()),
        ChangeNotifierProxyProvider<UserServices, UserViewModel>(
          create: (context) =>
              UserViewModel(userServices: context.read<UserServices>()),
          update: (context, services, previous) =>
              previous ?? UserViewModel(userServices: services),
        ),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider<ConnectionService>(
          create: (_) => BonsoirConnectionService(),
        ),
      ],
      child: const LingoHandsApp(),
    ),
  );
}

class LingoHandsApp extends StatelessWidget {
  const LingoHandsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const app_router.AppRouter();
  }
}
