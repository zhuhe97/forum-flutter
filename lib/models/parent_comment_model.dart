import 'package:forum_app/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parent_comment_model.g.dart';

@JsonSerializable()
class ParentComment {
  @JsonKey(name: '_id')
  final String? id;
  final String? content;
  @JsonKey(name: 'User')
  final User? author;

  ParentComment({
    this.author,
    this.id,
    this.content,
  });

  factory ParentComment.fromJson(Map<String, dynamic> json) =>
      _$ParentCommentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentCommentToJson(this);
}
