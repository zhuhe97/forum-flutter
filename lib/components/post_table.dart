import 'package:flutter/material.dart';
import 'package:forum_app/state/post.dart';
import "package:provider/provider.dart";

String formatElapsedTime(DateTime postTime) {
  final Duration difference = DateTime.now().difference(postTime);
  if (difference.inDays >= 1) {
    return '${difference.inDays}d';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}m';
  } else {
    return 'Just now';
  }
}

class PostsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postsModel = Provider.of<PostsModel>(context);

    if (postsModel.loading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
        itemCount: postsModel.posts.length,
        itemBuilder: (context, index) {
          final post = postsModel.posts[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.avatarUrl),
                        onBackgroundImageError: (_, __) => Icon(Icons.person),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.author,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatElapsedTime(
                                DateTime.parse(post.createdAt))),
                          ],
                        ),
                      ),
                      Text('${post.commentsCount} replies',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(post.title,
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 4),
                  Text(post.content),
                ],
              ),
            ),
          );
        });
  }
}
