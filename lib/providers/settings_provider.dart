import 'package:flutter/widgets.dart';
import 'package:zaratask/core/utils/service_locator.dart';
import 'package:zaratask/models/settings_model.dart';
import 'package:zaratask/services/supabae_database_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    required SupabaseDatabaseService db,
    required String ownerId,
  }) {
    _db = db;
    // Default settings
    _settings = Settings(
      ownerId: ownerId,
      darkMode: false,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    _init();
  }

  late SupabaseDatabaseService _db;

  // Default settings
  late Settings _settings;
  Settings get settings => _settings;

  void setOwnerId(String ownerId) {
    _settings = _settings.copyWith(ownerId: ownerId);
    notifyListeners();
  }

  Future<void> updateDarkMode(bool enabled) async {
    final response = await _db.updateDarkMode(
      enabled: enabled,
      ownerId: _settings.ownerId,
    );
    if (response.successful) {
      ServiceLocator.logger.i('Enabled dark mode: $enabled');
    } else {
      ServiceLocator.messenger.showError(
        response.message ?? 'Could not update dark mode',
      );
    }
  }

  Future<void> _createDefaultSettings() async {
    final response = await _db.insert(
      table: 'settings',
      data: _settings.toJson(),
    );
    if (response.successful) {
      ServiceLocator.logger.i('Created default settings: $settings');
    } else {
      ServiceLocator.messenger.showError(
        response.message ?? 'Could not create default settings',
      );
    }
  }

  void _init() {
    _db.streamSettings(_settings.ownerId).listen((response) async {
      final json = response.data;
      print('in settings provider stream settings got data');

      if (json == null) {
        if (_settings.ownerId.isNotEmpty) {
          print(
            'settings stream was null and an owner id is set and so creating a row',
          );
          await _createDefaultSettings();
          notifyListeners();
        }
        print(
          'settings stream was null but no owner id is set and so NOT creating a row',
        );
      } else {
        final newSettings = Settings.fromJson(json);
        print('got new settings updating provider');
        _settings = newSettings;
        notifyListeners();
      }
    });
  }
}
