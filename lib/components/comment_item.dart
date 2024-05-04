import 'package:flutter/material.dart';
import 'package:forum_app/models/comment_model.dart';
import 'package:forum_app/state/comment_model.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final CommentsModel provider;
  const CommentItem({super.key, required this.comment, required this.provider});

  @override
  Widget build(BuildContext context) {
    DateTime? commentTime;
    commentTime = DateTime.tryParse(comment.createdAt);

    String formattedTime = "Unknown";
    if (commentTime != null) {
      formattedTime = DateFormat.yMMMMd('en_US').format(commentTime);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                CircleAvatar(
                  backgroundImage: comment.author.avatarUrl != null
                      ? NetworkImage(comment.author.avatarUrl!)
                      : AssetImage('lib/assets/defaultAvatar.png')
                          as ImageProvider,
                  onBackgroundImageError: (_, __) => Icon(Icons.person),
                  radius: 12,
                ),
                SizedBox(width: 8),
                Text(
                  comment.author.username!,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ]),
              Row(
                children: [
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          if (comment.parentCommentStatus == ParentCommentStatus.Existing)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(8),
              width: 400,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${comment.parentComment.author!.username}  ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: comment.parentComment.content!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Text(comment.content),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    comment.isLikedByCurrentUser
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    size: 16,
                  ),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    provider.toggleLike(comment.id);
                  },
                ),
                Text(
                  comment.likeCount.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
