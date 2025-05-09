import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class LoggingService {
  LoggingService() {
    _init();
  }

  // Debug: for development messages only
  void d(String message) {
    Logger.root.fine(message);
  }

  // Info: for user information logging
  void i(String message) {
    Logger.root.info(message);
  }

  // Warning
  void w(String message) {
    Logger.root.warning(message);
  }

  // Error
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.root.severe(message, error, stackTrace);
  }

  String _getLevelLabel(Level level) {
    if (level == Level.FINEST) return 'TRACE';
    if (level == Level.FINER) return 'DEBUG';
    if (level == Level.FINE) return 'DEBUG';
    if (level == Level.CONFIG) return 'CONFIG';
    if (level == Level.INFO) return 'INFO';
    if (level == Level.WARNING) return 'WARN';
    if (level == Level.SEVERE) return 'ERROR';
    if (level == Level.SHOUT) return 'FATAL';
    return level.name;
  }

  Future<void> _init() async {
    // Remove Flutter's default logger to prefer the root logger
    Logger.root.clearListeners();
    //Logger.root.level = kReleaseMode ? Level.INFO : Level.FINE;
    Logger.root.onRecord.listen((record) {
      // This is the logging framework, so print is OK
      // ignore: avoid_print
      print(
        '${DateFormat('yyyy-MM-dd HH:mm:ss').format(record.time)}: ${_getLevelLabel(record.level)}: ${record.message}',
      );
    });
  }
}
