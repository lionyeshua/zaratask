import 'package:json_annotation/json_annotation.dart';
import 'package:zaratask/core/utils/json_converters/string_converter.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  const User({required this.id, required this.email, required this.userName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @StringConverter()
  final String id;

  @StringConverter()
  final String email;

  @StringConverter()
  final String userName;
}