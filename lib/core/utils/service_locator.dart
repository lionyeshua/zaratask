import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaratask/services/supabase_auth_service.dart';
import 'package:zaratask/services/messenger_service.dart';
import 'package:zaratask/services/supabae_database_service.dart';
import 'package:zaratask/services/logging_service.dart';
import 'package:zaratask/services/router_service.dart';

class ServiceLocator {
  static SupabaseAuthService get auth => GetIt.instance<SupabaseAuthService>();
  static SupabaseDatabaseService get db =>
      GetIt.instance<SupabaseDatabaseService>();
  static LoggingService get logger => GetIt.instance<LoggingService>();
  static MessengerService get messenger => GetIt.instance<MessengerService>();
  static RouterService get router => GetIt.instance<RouterService>();

  static void registerServices({required SupabaseClient supabase}) {
    // register supa
    GetIt.instance
      ..registerLazySingleton<SupabaseAuthService>(
        () => SupabaseAuthService(supabase.auth),
      )
      ..registerLazySingleton<SupabaseDatabaseService>(
        () => SupabaseDatabaseService(supabase),
      )
      ..registerLazySingleton<LoggingService>(() => LoggingService())
      ..registerLazySingleton<MessengerService>(() => MessengerService())
      ..registerLazySingleton<RouterService>(() => RouterService());
  }
}
