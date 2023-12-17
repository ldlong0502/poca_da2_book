
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/firebase_provider.dart';

import '../models/comment.dart';

class CommentCubit extends Cubit<int> {
  CommentCubit() : super(0);

  List<Comment> listComment = [];
  List<UserModel> listUserModel = [];

  load( int bookId , String type) async {
    listComment = await FireBaseProvider.instance.getAllComments(bookId, type);

    for(var i in listComment) {
      final user = await FireBaseProvider.instance.getUser(i.userId);
      if(user != null) {
        listUserModel.add(user);
      }
    }


    debugPrint('=>>>>>>> listUserModel: ${listUserModel.length}');
    emit(state+1);
  }

}
