import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zaratask/core/utils/json_converters/bool_converter.dart';
import 'package:zaratask/core/utils/json_converters/int_converter.dart';
import 'package:zaratask/core/utils/json_converters/string_converter.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart'; // Required for json_serializable

@freezed
abstract class Settings with _$Settings {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Settings({
    @StringConverter() required String ownerId,
    @BoolConverter() required bool darkMode,
    @IntConverter() required int createdAt,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  //Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
