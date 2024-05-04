// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:forum_app/components/comment_section.dart';
import 'package:forum_app/components/post_detail.dart';
import 'package:forum_app/state/comment_model.dart';
import 'package:provider/provider.dart';
import '../state/post_model.dart';

class PostPage extends StatefulWidget {
  final String postId;

  const PostPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final postsModel = Provider.of<PostsModel>(context, listen: false);
    final commentsModel = Provider.of<CommentsModel>(context, listen: false);
    commentsModel.resetComments();
    await postsModel.fetchPostDetail(widget.postId);
    await commentsModel.fetchComments(widget.postId, 2);
    commentsModel.setloadingEndPage(2);
    commentsModel.setloadingTopPage(2);
    setState(() {
      _loading = false;
    });
  }

  void _scrollToComments() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget _buildPersistentHeader() {
    return Container(
      height: 40,
      color: Colors.white,
      child: Center(
        child: TextButton(
          onPressed: _scrollToComments,
          child: Text("Comments", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  void _showAddCommentDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: 'Your Comment',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final commentContent = commentController.text;
                final commentsModel =
                    Provider.of<CommentsModel>(context, listen: false);

                if (commentContent.isNotEmpty) {
                  commentsModel.createComment(widget.postId, commentContent);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: _showAddCommentDialog,
          ),
        ],
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: PostDetails(
                  post: Provider.of<PostsModel>(context).currentPost!),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _CustomHeaderDelegate(_buildPersistentHeader()),
            ),
          ];
        },
        body: CommentsSection(postId: widget.postId),
      ),
    );
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomHeaderDelegate(this.child);

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
