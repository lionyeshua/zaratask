import 'package:json_annotation/json_annotation.dart';

/// Convert null, truthy/falsey bools, and non-bools to the specified default value bool.
class BoolConverter implements JsonConverter<bool, Object?> {
  const BoolConverter({this.defaultValue = false});

  final bool defaultValue;

  @override
  bool fromJson(Object? json) {
    if (json is bool) return json;
    if (json is int && json == 1) return true;
    if (json is int && json == 0) return false;
    return defaultValue;
  }

  @override
  Object toJson(bool value) => value;
}
