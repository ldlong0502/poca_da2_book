import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/utils/resizable.dart';

class ShimmerLoadingComment extends StatelessWidget {
  const ShimmerLoadingComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          height: Resizable.size(context, 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
        ));
  }
}
