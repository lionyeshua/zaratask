import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/models/database_response.dart';
import 'package:zaratask/models/settings_model.dart';

class SupabaseDatabaseService {
  SupabaseDatabaseService(this._db);

  final SupabaseClient _db;

  Future<DatabaseResponse<void>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final request = 'insert(table=$table, data=$data)';
    ServiceLocator.logger.i(request);

    try {
      await _db.from(table).insert(data);
      return DatabaseResponse.success();
    } on PostgrestException catch (error, stackTrace) {
      ServiceLocator.logger.e(request, error, stackTrace);
      return DatabaseResponse.error(message: error.message);
    } on Exception catch (error, stackTrace) {
      ServiceLocator.logger.e(request, error, stackTrace);
      return DatabaseResponse.error(message: 'Unexpected error');
    }
  }

  Stream<DatabaseResponse<Map<String, dynamic>?>> streamSettings(
    String ownerId,
  ) {
    final debugMessage = 'streamSettings(ownerId=$ownerId)';

    ServiceLocator.logger.d(debugMessage);
    return _db
        .from('settings')
        .stream(primaryKey: ['owner_id'])
        .map(
          (results) => DatabaseResponse.success(
            //rowsSelected: results.length,
            data: results.isEmpty ? null : results.first,
          ),
        )
        .distinct((previous, next) {
          if (previous.data == null && next.data == null) return true;
          if (previous.data == null || next.data == null) return false;

          return const DeepCollectionEquality().equals(
            previous.data,
            next.data,
          );
        })
        .handleError((Object e, StackTrace stackTrace) {
          ServiceLocator.logger.e('Stream error todo', e, stackTrace);
          return DatabaseResponse<void>.error(message: 'A stream error todo');
        });
  }

  Future<DatabaseResponse<void>> updateDarkMode({
    required bool enabled,
    required String ownerId,
  }) async {
    final request = 'updateDarkMode(enabled=$enabled, ownerId=$ownerId)';
    ServiceLocator.logger.i(request);

    try {
      await _db
          .from('settings')
          .update({'dark_mode': enabled})
          .eq('owner_id', ownerId);
      return DatabaseResponse.success();
    } on PostgrestException catch (error, stackTrace) {
      Logger.root.shout('I am shouting at you');
      ServiceLocator.logger.e(request, error, stackTrace);
      return DatabaseResponse.error(message: 'Could not update dark mode');
    } on Exception catch (error, stackTrace) {
      ServiceLocator.logger.e(request, error, stackTrace);
      return DatabaseResponse.error(message: 'Could not update dark mode');
    }
  }

  /*
  Future<DatabaseResponse<void>> delete(
    String table, [
    List<Object?> params = const [],
  ]) async {
    final debugMessage = 'delete($sql, $params)';

    try {
      ServiceLocator.logger.d(debugMessage);

      await _db.execute(sql, params);
      await _db.from('countries').delete().eq('id', 1);
      return DatabaseResponse.success();
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return DatabaseResponse.error(message: 'Unexpected error');
    }
  }

  Future<DatabaseResponse<void>> insertOne(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    final debugMessage = 'insertOne($sql, $params)';

    try {
      ServiceLocator.logger.d(debugMessage);
      await _db.execute(sql, params);
      return DatabaseResponse.success(rowsInserted: 1);
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return DatabaseResponse.error(message: 'Unexpected error');
    }
  }

  Future<DatabaseResponse<List<Map<String, dynamic>>>> selectAll(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    final debugMessage = 'selectAll($sql, $params)';

    try {
      ServiceLocator.logger.d(debugMessage);
      final result = await _db.getAll(sql, params);
      return DatabaseResponse.success(
        rowsSelected: result.length,
        data: result,
      );
    } on Exception catch (e, s) {
      ServiceLocator.logger.e(debugMessage, e, s);
      return DatabaseResponse.error(message: 'Unexpected error');
    }
  }

  Stream<DatabaseResponse<List<Map<String, dynamic>>>> stream(
    String sql, [
    List<Object?> params = const [],
  ]) {
    final debugMessage = 'stream($sql, $params)';

    ServiceLocator.logger.d(debugMessage);
    return _db
        .watch(sql, parameters: params)
        .map(
          (results) => DatabaseResponse.success(
            rowsSelected: results.length,
            data: results,
          ),
        )
        .distinct((previous, next) {
          if (previous.data == null && next.data == null) return true;
          if (previous.data == null || next.data == null) return false;

          return const DeepCollectionEquality().equals(
            previous.data,
            next.data,
          );
        })
        .handleError((Object e, StackTrace stackTrace) {
          ServiceLocator.logger.e('Stream error todo', e, stackTrace);
          return DatabaseResponse<void>.error(message: 'A stream error todo');
        });
  }


  */
}
