import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/di.dart';
import '../app.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  observers: [TalkerRouteObserver(talker)],
  debugLogDiagnostics: true,
  initialLocation: '/login',
  navigatorKey: _rootNavigationKey,
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/details/:id',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: DetailsScreen(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
    ),
  ],
);
