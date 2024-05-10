import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class Member {
  @JsonKey(name: '_id')
  String id;
  String username;
  String? avatar;
  int followersCount;
  int followingsCount;
  bool? isFollowing;

  Member({
    required this.id,
    required this.username,
    required this.followersCount,
    required this.followingsCount,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
