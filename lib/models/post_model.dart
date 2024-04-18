import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
part 'post_model.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String content;
  @JsonKey(name: 'user')
  final User author;
  final int? commentsCount;
  final String createdAt;
  final String? updatedAt;
  final String? lastReplyTime;

  Post(
      {this.id,
      required this.title,
      required this.author,
      required this.content,
      required this.commentsCount,
      required this.createdAt,
      this.updatedAt,
      this.lastReplyTime});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
