// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forum_app/state/user_model.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    await userModel.logout();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Username: exampleUser', style: TextStyle(fontSize: 20)),
          Text('Email: user@example.com', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
