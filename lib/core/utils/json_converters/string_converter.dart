import 'package:json_annotation/json_annotation.dart';

/// Convert null and non-Strings to the specified default value String.
class StringConverter implements JsonConverter<String, Object?> {
  const StringConverter({this.defaultValue = ''});

  final String defaultValue;

  @override
  String fromJson(Object? json) {
    if (json is String) return json;
    return defaultValue;
  }

  @override
  Object toJson(String value) => value;
}
