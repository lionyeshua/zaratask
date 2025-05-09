import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaratask/screens/home_screen.dart';
import 'package:zaratask/screens/page_not_found_screen.dart';
import 'package:zaratask/screens/profile_screen.dart';
import 'package:zaratask/screens/sign_in_screen.dart' show SignInScreen;
import 'package:zaratask/screens/topics_screen.dart';
import 'package:zaratask/screens/update_email_screen.dart';
import 'package:zaratask/screens/verify_otp_for_email_sign_in_screen.dart';
import 'package:zaratask/screens/verify_otp_for_email_update_screen.dart';

class RouterService {
  static GoRouter authenticatedRouter() => GoRouter(
    errorPageBuilder:
        (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const PageNotFoundScreen(),
        ),
    initialLocation: '/tasks',
    redirect: (context, state) {
      print('on ${state.fullPath}');
      print('redirecting');
      return null;
    },
    routes: [
      // Home screen stack
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => HomeScreen(child),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            initialLocation: '/tasks',
            routes: <RouteBase>[
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TopicsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: '/profile',
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'update-email',
                    builder:
                        (context, state) =>
                            UpdateEmailScreen(state.extra as String?),
                  ),
                  GoRoute(
                    path: 'verify-email',
                    builder:
                        (context, state) => VerifyOtpForEmailUpdateScreen(
                          state.extra as String?,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter unauthenticatedRouter() => GoRouter(
    errorPageBuilder:
        (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const PageNotFoundScreen(),
        ),
    initialLocation: '/sign-in',
    routes: [
      // Auth
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/verify-sign-in',
        builder:
            (context, state) =>
                VerifyOtpForEmailSignInScreen(state.extra as String?),
      ),
    ],
  );
}
