// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['_id'] as String,
      content: json['content'] as String,
      postId: json['post'] as String,
      author: User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      likeCount: json['likeCount'] as int,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool,
      parentComment:
          ParentComment.fromJson(json['parentComment'] as Map<String, dynamic>),
      parentCommentStatus: $enumDecode(
          _$ParentCommentStatusEnumMap, json['parentCommentStatus']),
      page: json['page'] as int? ?? 0,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'post': instance.postId,
      'user': instance.author,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'likeCount': instance.likeCount,
      'isLikedByCurrentUser': instance.isLikedByCurrentUser,
      'parentComment': instance.parentComment,
      'parentCommentStatus':
          _$ParentCommentStatusEnumMap[instance.parentCommentStatus]!,
      'page': instance.page,
    };

const _$ParentCommentStatusEnumMap = {
  ParentCommentStatus.NoParentEver: 'NoParentEver',
  ParentCommentStatus.Deleted: 'Deleted',
  ParentCommentStatus.AuthorDelete: 'AuthorDelete',
  ParentCommentStatus.Existing: 'Existing',
};
