// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forum_app/components/comment_section.dart';
import 'package:forum_app/components/post_detail.dart';
import 'package:provider/provider.dart';
import '../state/post.dart';

class PostPage extends StatefulWidget {
  final String postId;

  const PostPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchData());
  }

  void _fetchData() {
    final postsModel = Provider.of<PostsModel>(context, listen: false);
    postsModel.fetchPostDetail(widget.postId);
    postsModel.fetchComments(widget.postId, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Consumer<PostsModel>(
        builder: (context, provider, child) {
          if (provider.loading || provider.currentPost == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              PostDetails(post: provider.currentPost!),
              CommentsSection(postId: widget.postId),
            ],
          );
        },
      ),
    );
  }
}
