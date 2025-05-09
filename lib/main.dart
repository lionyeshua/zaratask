import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaratask/core/utils/service_locator.dart';

import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/providers/settings_provider.dart';
import 'package:zaratask/screens/initialization_failed_screen.dart';

import 'package:zaratask/services/router_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var hasInitializationError = false;
  var initializationErrorMessage = '';

  try {
    await dotenv.load();

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null) {
      throw Exception('Missing supabaseUrl in .env file');
    } else if (supabaseAnonKey == null) {
      throw Exception('Missing supabaseAnonKey in .env file');
    }

    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    ServiceLocator.registerServices(supabase: supabase.client);
  } on Exception catch (error, stackTrace) {
    hasInitializationError = true;
    initializationErrorMessage = error.toString();
    Logger.root.shout(initializationErrorMessage, [error, stackTrace]);
  }
  if (hasInitializationError) {
    runApp(ErrorApp(initializationErrorMessage));
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(auth: ServiceLocator.auth),
          ),
        ],
        child: const MainApp(),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp(this.errorMessage, {super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: InitializationFailedScreen(errorMessage));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.isAuthenticated) {
          ServiceLocator.logger.i(
            'User is authenticated. Running authenticated app.',
          );
          return ChangeNotifierProvider(
            create:
                (context) => SettingsProvider(
                  db: ServiceLocator.db,
                  ownerId: provider.user.id,
                ),
            child: AuthenticatedApp(),
          );
        } else {
          ServiceLocator.logger.i(
            'User is not authenticated. Running unauthenticated app.',
          );
          return UnauthenticatedApp();
        }
      },
    );
  }
}

class AuthenticatedApp extends StatelessWidget {
  const AuthenticatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = RouterService.authenticatedRouter();

    return Selector<SettingsProvider, bool>(
      selector: (context, provider) => provider.settings.darkMode,
      builder: (context, darkMode, child) {
        return MaterialApp.router(
          scaffoldMessengerKey: ServiceLocator.messenger.messengerKey,
          routerConfig: router,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}

class UnauthenticatedApp extends StatelessWidget {
  const UnauthenticatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: ServiceLocator.messenger.messengerKey,
      routerConfig: RouterService.unauthenticatedRouter(),
    );
  }
}
