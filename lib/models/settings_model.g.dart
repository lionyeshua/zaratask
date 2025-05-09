// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  ownerId: const StringConverter().fromJson(json['owner_id']),
  darkMode: const BoolConverter().fromJson(json['dark_mode']),
  createdAt: const IntConverter().fromJson(json['created_at']),
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'owner_id': const StringConverter().toJson(instance.ownerId),
  'dark_mode': const BoolConverter().toJson(instance.darkMode),
  'created_at': const IntConverter().toJson(instance.createdAt),
};
