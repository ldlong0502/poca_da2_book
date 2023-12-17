import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:poca/blocs/comment_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/utils/dialogs.dart';
import 'package:poca/utils/resizable.dart';



class CommentDetail extends StatelessWidget {
  const CommentDetail({super.key, required this.commentCubit });
  final CommentCubit commentCubit;
  @override
  Widget build(BuildContext context) {
    final listComment = commentCubit.listComment;


    return Container();
  }
}
