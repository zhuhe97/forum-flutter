import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:forum_app/models/comment_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentsModel extends ChangeNotifier {
  List<Comment> comments = [];
  bool _loading = false;
  int _loadingTopPage = 0;
  int _loadingEndPage = 0;
  int _totalPages = 0;
  int _currentPage = 0;

  final dio = Dio();
  final storage = FlutterSecureStorage();

  int get totalPages => _totalPages;
  int get loadingTopPage => _loadingTopPage;
  int get loadingEndPage => _loadingEndPage;
  int get currentPage => _currentPage;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setloadingEndPage(int page) {
    _loadingEndPage = page;
    notifyListeners();
  }

  void setloadingTopPage(int page) {
    _loadingTopPage = page;
    notifyListeners();
  }

  void setCurrentPage(int maxVisiblePage) {
    _currentPage = maxVisiblePage;
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }

  void resetComments() {
    comments = [];
    _loadingTopPage = 0;
    _loadingEndPage = 0;
    _totalPages = 0;
    _currentPage = 0;
  }

  Future<void> fetchComments(
    String postId,
    int page,
  ) async {
    if (_loading) return;
    setLoading(true);

    try {
      final response = await dio.get(
        'http://10.0.2.2:8888/api/v1/posts/$postId/comments?page=$page&limit=10',
      );
      final jsonData = response.data['comments'];
      final totalPages = response.data['totalPages'];

      final List<Comment> newComments = List<Comment>.from(
        jsonData.map((json) {
          var comment = Comment.fromJson(json);
          comment.page = page;
          return comment;
        }),
      );

      //记录临界值
      if (page > loadingEndPage) {
        comments = comments + newComments;
        setloadingEndPage(page);
      } else {
        comments = newComments + comments;
        setloadingTopPage(page);
      }

      setTotalPages(totalPages);
      notifyListeners();
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> toggleLike(String commentId) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response =
          await dio.post('http://10.0.2.2:8888/api/v1/toggleLike/$commentId');
      if (response.statusCode == 200) {
        print('${response.data}');
        final index = comments.indexWhere((comment) => comment.id == commentId);
        if (index != -1) {
          final comment = comments[index];
          comment.isLikedByCurrentUser = !comment.isLikedByCurrentUser;
          comment.likeCount += comment.isLikedByCurrentUser ? 1 : -1;
          notifyListeners();
        }
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    }
  }

  Future<void> createComment(String postId, String content) async {
    setLoading(true);
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio
          .post('http://10.0.2.2:8888/api/v1/posts/$postId/comments', data: {
        'content': content,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        fetchComments(postId, 1);
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> replyComment(
      String postId, String parentCommentId, String content) async {
    setLoading(true);
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio
          .post('http://10.0.2.2:8888/api/v1/posts/$postId/comments', data: {
        'content': content,
        'parentCommentId': parentCommentId,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        fetchComments(postId, 1);
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      setLoading(false);
    }
  }
}
