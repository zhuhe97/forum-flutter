// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentComment _$ParentCommentFromJson(Map<String, dynamic> json) =>
    ParentComment(
      author: json['User'] == null
          ? null
          : User.fromJson(json['User'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$ParentCommentToJson(ParentComment instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'User': instance.author,
    };
