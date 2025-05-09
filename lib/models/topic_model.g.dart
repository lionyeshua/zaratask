// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
  id: const StringConverter().fromJson(json['id']),
  name: const StringConverter().fromJson(json['name']),
  ownerId: const StringConverter().fromJson(json['owner_id']),
  createdAt: const IntConverter().fromJson(json['created_at']),
);

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
  'id': const StringConverter().toJson(instance.id),
  'name': const StringConverter().toJson(instance.name),
  'owner_id': const StringConverter().toJson(instance.ownerId),
  'created_at': const IntConverter().toJson(instance.createdAt),
};
