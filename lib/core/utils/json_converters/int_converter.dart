import 'package:json_annotation/json_annotation.dart';

/// Convert null and non-ints to the specified default value int.
class IntConverter implements JsonConverter<int, Object?> {
  const IntConverter({this.defaultValue = 0});

  final int defaultValue;

  @override
  int fromJson(Object? json) {
    if (json is int) return json;
    return defaultValue;
  }

  @override
  Object toJson(int value) => value;
}
