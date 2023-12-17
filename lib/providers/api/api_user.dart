import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiUser {
  ApiUser._privateConstructor();

  static final ApiUser _instance = ApiUser._privateConstructor();

  static ApiUser get instance => _instance;

  Future<bool> updateUser(String idUser, Map<String, dynamic> data) async {
    var response = await ApiProvider().update('/users/$idUser', data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
