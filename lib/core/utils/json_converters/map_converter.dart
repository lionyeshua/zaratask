import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

/// Convert null, String, and non-Maps to the specified default value Map.
class MapConverter implements JsonConverter<Map<String, dynamic>, Object?> {
  const MapConverter({this.defaultValue = const {}});

  final Map<String, dynamic> defaultValue;

  @override
  Map<String, dynamic> fromJson(Object? json) {
    if (json is Map<String, dynamic>) return json;
    if (json is String) {
      if (json.isEmpty) return defaultValue;

      // Try to decode if it's a JSON encoded string
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    // Convert non-string keys to string keys
    if (json is Map && !json.keys.every((k) => k is String)) {
      return json.map((key, value) => MapEntry(key.toString(), value));
    }

    return defaultValue;
  }

  @override
  Object toJson(Map<String, dynamic> value) {
    return value;
  }
}
