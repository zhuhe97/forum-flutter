import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forum_app/models/comment_model.dart';
import 'package:forum_app/models/post_model.dart';

class PostsModel extends ChangeNotifier {
  List<Post> _posts = [];
  bool _loading = false;
  int _currentPage = 1;
  int _totalPages = 0;
  Post? currentPost;
  List<Comment> comments = [];

  List<Post> get posts => _posts;
  bool get loading => _loading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  final dio = Dio();
  final storage = FlutterSecureStorage();

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    if (_loading) return;
    setLoading(true);

    try {
      final response = await dio
          .get('http://10.0.2.2:8888/api/v1/posts?page=$_currentPage&limit=10');
      final jsonData = response.data['data']['data'];
      List<Post> newPosts =
          List<Post>.from(jsonData.map((json) => Post.fromJson(json)));
      if (newPosts.isNotEmpty) {
        _posts.addAll(newPosts);
        setCurrentPage(_currentPage + 1);
        _totalPages = response.data['data']['totalPages'];
        notifyListeners();
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchPostDetail(String postId) async {
    setLoading(true);
    try {
      final response =
          await dio.get('http://10.0.2.2:8888/api/v1/posts/$postId');
      if (response.statusCode == 200) {
        currentPost = Post.fromJson(response.data);
        notifyListeners();
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchComments(String postId, int page) async {
    try {
      final response = await dio
          .get('http://10.0.2.2:8888/api/v1/posts/$postId/comments?page=$page');
      final jsonData = response.data['comments'];

      comments = List<Comment>.from(
          jsonData?.map((data) => Comment.fromJson(data)) ?? []);

      notifyListeners();
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    }
  }

  Future<void> createPost(String title, String content) async {
    setLoading(true);
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio.post('http://10.0.2.2:8888/api/v1/posts',
          data: {'title': title, 'content': content});
      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        setCurrentPage(1);
        _posts = [];
        await fetchPosts();
      }
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
}
