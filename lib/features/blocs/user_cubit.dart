import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';

import '../../models/user_model.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  List<Podcast> listSubscribes = [];
  update(UserModel? value) async {
    emit(value);
  }


}
