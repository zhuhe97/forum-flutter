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
  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () => print('add comment'),
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
