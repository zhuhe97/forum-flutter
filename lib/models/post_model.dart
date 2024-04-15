class Post {
  final String id;
  final String title;
  final String author;
  final String content;
  final String avatarUrl;
  final int commentsCount;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.avatarUrl,
    required this.commentsCount,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      author: json['user']['username'] ?? 'Author Name',
      content: json['content'],
      avatarUrl: json['user']['avatar'] ?? 'default-avatar-url',
      commentsCount: json['commentsCount'],
      createdAt: json['createdAt'],
    );
  }
}
