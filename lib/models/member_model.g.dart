// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: json['_id'] as String,
      username: json['username'] as String,
      followersCount: json['followersCount'] as int,
      followingsCount: json['followingsCount'] as int,
    )
      ..avatar = json['avatar'] as String?
      ..isFollowing = json['isFollowing'] as bool?;

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
      'followersCount': instance.followersCount,
      'followingsCount': instance.followingsCount,
      'isFollowing': instance.isFollowing,
    };
