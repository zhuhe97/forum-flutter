import 'package:flutter/material.dart';
import 'package:forum_app/models/member_model.dart';
import 'package:forum_app/service/services.dart';

class MemberModel extends ChangeNotifier {
  final String userId;
  Member? member;

  MemberModel({required this.userId}) {
    fetchMemberProfile();
  }

  Future<void> fetchMemberProfile() async {
    final response = await Services.asyncRequest('GET', '/users/$userId');
    member = Member.fromJson(response.data);

    notifyListeners();
  }
}
