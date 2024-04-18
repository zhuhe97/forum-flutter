// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['_id'] as String?,
      title: json['title'] as String,
      author: User.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      commentsCount: json['commentsCount'] as int?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      lastReplyTime: json['lastReplyTime'] as String?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'user': instance.author,
      'commentsCount': instance.commentsCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'lastReplyTime': instance.lastReplyTime,
    };
