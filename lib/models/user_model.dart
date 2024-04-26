import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String? username;
  final String? avatarUrl;
  @JsonKey(name: '_id')
  final String? id;
  User({
    this.id,
    this.username,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['username'] ?? json['name'];
    final avatarUrl = json['avatarUrl'];

    return User(
      id: json['_id'],
      username: name,
      avatarUrl: avatarUrl,
    );
  }
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
