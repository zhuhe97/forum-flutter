// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../state/user_model.dart';

class AuthCheck extends StatelessWidget {
  final Widget child;

  const AuthCheck({required this.child});

  @override
  Widget build(BuildContext context) {
    print("AuthCheck build called");

    final userModel = UserModel();

    return StreamBuilder<bool>(
      stream: userModel.authStream,
      initialData: userModel.isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data ?? false) {
          return child;
        } else {
          Future.delayed(
              Duration.zero,
              () => Navigator.pushNamed(context,
                  '/login')); // make sure navigation after widget build

          return Center(child: Text('You didn\'t login'));
        }
      },
    );
  }
}
