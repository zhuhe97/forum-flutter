import 'package:forum_app/models/parent_comment_model.dart';
import 'package:forum_app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: '_id')
  final String id;
  final String content;
  @JsonKey(name: 'post')
  final String postId;
  @JsonKey(name: 'user')
  final User author;
  final String createdAt;
  final String updatedAt;
  int likeCount;
  bool isLikedByCurrentUser;
  final ParentComment parentComment;
  final ParentCommentStatus parentCommentStatus;
  int page;
  Comment({
    required this.id,
    required this.content,
    required this.postId,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.isLikedByCurrentUser,
    required this.parentComment,
    required this.parentCommentStatus,
    this.page = 0,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

enum ParentCommentStatus {
  NoParentEver,
  Deleted,
  AuthorDelete,
  Existing,
}
