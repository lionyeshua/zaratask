// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: const StringConverter().fromJson(json['id']),
  email: const StringConverter().fromJson(json['email']),
  userName: const StringConverter().fromJson(json['user_name']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': const StringConverter().toJson(instance.id),
  'email': const StringConverter().toJson(instance.email),
  'user_name': const StringConverter().toJson(instance.userName),
};
