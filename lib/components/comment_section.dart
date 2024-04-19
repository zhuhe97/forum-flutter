import 'package:flutter/material.dart';
import '../state/post.dart';
import 'package:provider/provider.dart';

class CommentsSection extends StatelessWidget {
  final String postId;

  CommentsSection({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsModel>(
      builder: (context, provider, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.comments.length,
          itemBuilder: (context, index) {
            final comment = provider.comments[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      CircleAvatar(
                        backgroundImage: comment.author.avatarUrl != null
                            ? NetworkImage(comment.author.avatarUrl!)
                            : AssetImage('lib/assets/defaultAvatar.png')
                                as ImageProvider,
                        onBackgroundImageError: (_, __) => Icon(Icons.person),
                        radius: 16,
                      ),
                      Text(comment.author.username!,
                          style: TextStyle(color: Colors.black))
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(comment.content),
                    ),
                  ]),
            );
          },
        );
      },
    );
  }
}
