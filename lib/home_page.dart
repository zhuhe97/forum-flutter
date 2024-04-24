import 'package:flutter/material.dart';
import 'package:forum_app/components/auth_check.dart';
import 'package:forum_app/state/user_model.dart';
import 'package:forum_app/routes/create_post.dart';
import 'package:forum_app/routes/user.dart';
import 'package:forum_app/state/post.dart';
import 'components/post_table.dart';
import "package:provider/provider.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    Future.delayed(Duration.zero, () {
      Provider.of<PostsModel>(context, listen: false).fetchPosts();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(_selectedIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(child: PostsTable()),
            AuthCheck(child: UserProfilePage()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Me',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final userModel = Provider.of<UserModel>(context, listen: false);
            if (userModel.isLoggedIn) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePostPage()));
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
          child: Icon(Icons.edit),
          tooltip: 'Create Post',
        ),
      ),
    );
  }
}
