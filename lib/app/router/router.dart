import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../di/di.dart';
import '../app.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  observers: [TalkerRouteObserver(talker)],
  debugLogDiagnostics: true,
  initialLocation: '/home',
  navigatorKey: _rootNavigationKey,
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    

    
    GoRoute(
      path: '/details',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: DetailsScreen(
          item: state.extra as ContentItem? ?? kContentItems.first,
        ),
      ),
    ),
  ],
);
