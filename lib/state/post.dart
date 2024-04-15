import 'package:flutter/material.dart';
import 'package:forum_app/models/post_model.dart';
import 'package:dio/dio.dart';

class PostsModel extends ChangeNotifier {
  List<Post> _posts = [];
  bool _loading = false;
  int _currentPage = 1;
  int _totalPages = 0;

  List<Post> get posts => _posts;
  bool get loading => _loading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

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
    setLoading(true);
    // try {
    //   print('loading.,......');
    //   final response = await Services.asyncRequest(
    //     'GET',
    //     'api/v1/posts',
    //   );
    //   print(response);
    //   List<dynamic> jsonData = json.decode(response);

    //   _posts = jsonData.map((json) => Post.fromJson(json)).toList();
    //   setLoading(false);
    // } catch (e) {
    //   setLoading(false);
    // }

    var dio = Dio();
    try {
      final response =
          await dio.get('http://10.0.2.2:3000/api/v1/posts?page=1&limit=10');
      final jsonData = response.data['data']['data'];
      _posts = jsonData.map<Post>((json) => Post.fromJson(json)).toList();
      setLoading(false);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error:');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      setLoading(false);
    }
  }
}
