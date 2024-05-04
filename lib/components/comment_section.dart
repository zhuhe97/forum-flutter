// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forum_app/components/comment_item.dart';
import 'package:forum_app/state/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CommentsSection extends StatefulWidget {
  final String postId;

  CommentsSection({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  int currentVisiblePage = 0;
  Map<String, double> visibilityMap = {};
  bool isLoading = false;
  late ScrollController _scrollController;
  // Timer? _throttle;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _throttle?.cancel();

    super.dispose();
  }

  // void updateVisiblePageThrottled() {
  //   if (_throttle?.isActive ?? false) return;

  //   _throttle = Timer(const Duration(milliseconds: 300), () {
  //     updateVisiblePage();
  //     _throttle = null;
  //   });
  // }

  void _scrollListener() {
    final commentsModel = Provider.of<CommentsModel>(context, listen: false);

    if (_scrollController.position.atEdge) {
      setState(() {
        isLoading = true;
      });

      if (_scrollController.position.pixels > 0) {
        // scroll down and load comments of next page
        if (commentsModel.loadingEndPage < commentsModel.totalPages) {
          commentsModel.fetchComments(
              widget.postId, commentsModel.loadingEndPage + 1);
        }
      } else {
        // scroll up and load comments of last page
        if (commentsModel.loadingTopPage > 1) {
          commentsModel.fetchComments(
              widget.postId, commentsModel.loadingTopPage - 1);
        }
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPageSelector(BuildContext context) {
    final commentsModel = Provider.of<CommentsModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: commentsModel.totalPages,
            itemBuilder: (context, index) {
              final page = index + 1;

              return ListTile(
                title: Text('Page $page'),
                onTap: () async {
                  commentsModel.resetComments();
                  visibilityMap.clear();
                  await commentsModel.fetchComments(widget.postId, page);
                  commentsModel.setCurrentPage(page);
                  commentsModel.setloadingEndPage(page);
                  commentsModel.setloadingTopPage(page);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showReplyDialog(
      BuildContext context, String postId, String parentCommentId) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reply to Comment'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
              labelText: 'Your Reply',
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
                final replyContent = replyController.text;
                if (replyContent.isNotEmpty) {
                  final provider =
                      Provider.of<CommentsModel>(context, listen: false);
                  provider.replyComment(postId, parentCommentId, replyContent);
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

  void updateVisiblePage() {
    if (mounted && visibilityMap.isNotEmpty) {
      final lastVisibleComment = visibilityMap.entries
          .reduce((curr, next) => next.value > curr.value ? next : curr);
      int page = Provider.of<CommentsModel>(context, listen: false)
          .comments[int.parse(lastVisibleComment.key)]
          .page;

      if (page != currentVisiblePage) {
        setState(() {
          currentVisiblePage = page;
          Provider.of<CommentsModel>(context, listen: false)
              .setCurrentPage(currentVisiblePage);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsModel>(
      builder: (context, provider, child) {
        return Stack(alignment: Alignment.bottomRight, children: [
          ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => Divider(),
            // shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: provider.comments.length,
            itemBuilder: (context, index) {
              final commentList = provider.comments;
              final comment = commentList[index];

              if (isLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return VisibilityDetector(
                  key: Key('comment-${provider.comments[index].id}'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    visibilityMap['$index'] = info.visibleFraction;
                    if (info.visibleFraction == 0) {
                      visibilityMap.remove('$index');
                    }
                    updateVisiblePage();
                  },
                  child: InkWell(
                    onTap: () {
                      _showReplyDialog(context, widget.postId, comment.id);
                    },
                    child: CommentItem(comment: comment, provider: provider),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _showPageSelector(context);
              },
              borderRadius: BorderRadius.circular(50.0),
              highlightColor: Colors.grey.withOpacity(0.3),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.withOpacity(0.2)),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Page ${provider.currentPage} / ${provider.totalPages}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
