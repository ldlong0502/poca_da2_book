import 'package:flutter/material.dart';
import 'package:poca_book/models/topic.dart';
import 'package:poca_book/models/user_model.dart';
import 'package:poca_book/providers/api/api_provider.dart';
import 'package:poca_book/providers/preference_provider.dart';
import 'package:poca_book/providers/user/user_provider.dart';

class ApiTopic {
  ApiTopic._privateConstructor();

  static final ApiTopic _instance = ApiTopic._privateConstructor();

  static ApiTopic get instance => _instance;

  Future<List<Topic>> getListTopics() async {
    var response = await ApiProvider().get('/topics');
    debugPrint(response.toString());
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Topic> topics =
      (response.data as List).map((e) => Topic.fromJson(e)).toList();
      return topics;
    } else {
      return [];
    }
  }
}