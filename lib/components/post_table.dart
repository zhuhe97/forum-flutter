// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forum_app/models/post_model.dart';
import 'package:forum_app/state/post.dart';
import "package:provider/provider.dart";
import 'post_page.dart';

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

    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: postsModel.posts.length +
            (postsModel.currentPage <= postsModel.totalPages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == postsModel.posts.length) {
            return Center(child: CircularProgressIndicator());
          }
          final post = postsModel.posts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    postId: post.id!,
                  ),
                ),
              );
            },
            child: postItem(context, post),
          );
        });
  }

  Widget postItem(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Icon(
              Icons.message,
              size: 16,
              color: Colors.grey,
            ),
            Text('${post.commentsCount} ',
                style: TextStyle(color: Colors.grey[600])),
          ]),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.title,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: post.author.avatarUrl != null
                        ? NetworkImage(post.author.avatarUrl!)
                        : AssetImage('lib/assets/defaultAvatar.png')
                            as ImageProvider,
                    onBackgroundImageError: (_, __) => Icon(Icons.person),
                    radius: 10,
                  ),
                  SizedBox(width: 8),
                  Text(post.author.username!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  SizedBox(width: 8),
                  Text(
                    formatElapsedTime(DateTime.parse(post.createdAt)),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
