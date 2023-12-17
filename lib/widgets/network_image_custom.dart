import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/resizable.dart';

class NetworkImageCustom extends StatelessWidget {
  const NetworkImageCustom(
      {super.key,
      required this.url,
      required this.borderRadius,
      this.width,
      this.height});

  final String url;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.fill,
        width: width,
        height: height,
        placeholder: (context, url) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[100]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius),
                child: const Text(''),
              ));
        },
      ),
    );
  }
}
