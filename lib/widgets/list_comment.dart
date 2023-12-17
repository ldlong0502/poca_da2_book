import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/comment/comment_detail.dart';
import 'package:poca/features/comment/empty_comment.dart';
import 'package:poca/features/comment/shimmer_loading_comment.dart';

import '../blocs/comment_cubit.dart';

class ListComment extends StatelessWidget {
  const ListComment({super.key, required this.bookId, required this.type});
  final int bookId;
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentCubit()..load(bookId, type),
      child: BlocBuilder<CommentCubit, int>(
          builder: (context, i) {
            final cubit = context.read<CommentCubit>();
            if(i == 0) {
              return const ShimmerLoadingComment();
            }
            if(cubit.listComment.isEmpty) {
              return const EmptyComment();
            }
            return CommentDetail(commentCubit: cubit);
          }
      ),
    );
  }
}