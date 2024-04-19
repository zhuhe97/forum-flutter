// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              CircleAvatar(
                backgroundImage: post.author.avatarUrl != null
                    ? NetworkImage(post.author.avatarUrl!)
                    : AssetImage('lib/assets/defaultAvatar.png')
                        as ImageProvider,
                onBackgroundImageError: (_, __) => Icon(Icons.person),
                radius: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.username!,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(post.createdAt, style: TextStyle(color: Colors.grey))
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Text(post.content),
                  ]))
        ],
      ),
    );
  }
}
