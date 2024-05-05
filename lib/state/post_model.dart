import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forum_app/models/comment_model.dart';
import 'package:forum_app/models/post_model.dart';
import 'package:forum_app/service/services.dart';

class PostsModel extends ChangeNotifier {
  List<Post> _posts = [];
  bool _loading = false;
  int _currentPage = 1;
  int _totalPages = 0;
  Post? currentPost;
  List<Comment> comments = [];

  List<Post> get posts => _posts;
  // bool get loading => _loading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  final dio = Dio();
  final storage = FlutterSecureStorage();

  // void setLoading(bool loading) {
  //   _loading = loading;
  //   notifyListeners();
  // }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTotalPages(int totalPages) {
    _totalPages = totalPages;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    // if (_loading) return;
    // setLoading(true);

    try {
      Map<String, dynamic> queryParams = {
        'page': _currentPage.toString(),
        'limit': 10.toString(),
      };
      final response =
          await Services.asyncRequest('GET', '/posts', params: queryParams);

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
      // setLoading(false);
    }
  }

  Future<void> fetchPostDetail(String postId) async {
    // setLoading(true);
    try {
      final response = await Services.asyncRequest('GET', '/posts/$postId');

      if (response.statusCode == 200) {
        currentPost = Post.fromJson(response.data);
        notifyListeners();
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      // setLoading(false);
    }
  }

  Future<void> createPost(String title, String content) async {
    // setLoading(true);
    try {
      final response = await Services.asyncRequest('POST', '/posts',
          payload: {'title': title, 'content': content});

      if (response.statusCode == 200 || response.statusCode == 201) {
        // setLoading(false);
        setCurrentPage(1);
        _posts = [];
        await fetchPosts();
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.message}');
    } finally {
      // setLoading(false);
    }
  }
}
