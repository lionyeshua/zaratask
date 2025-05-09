import 'package:json_annotation/json_annotation.dart';
import 'package:zaratask/core/utils/json_converters/int_converter.dart';
import 'package:zaratask/core/utils/json_converters/string_converter.dart';

part 'topic_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Topic {
  const Topic({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  @StringConverter()
  final String id;

  @StringConverter()
  final String name;

  @StringConverter()
  final String ownerId;

  @IntConverter()
  final int createdAt;
}
