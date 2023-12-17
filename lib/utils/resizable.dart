import 'dart:math';

import 'package:flutter/cupertino.dart';

class Resizable {
  static double font(BuildContext context, double size) {
    return fontScaleRatioForTablet(context) * width(context) *size / standard(context);
  }

  static double padding(BuildContext context, double size) {

    return paddingScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));
  }

  static double borderPadding(BuildContext context, double size) {
    return borderPaddingScaleRatioForTablet(context) *
        size *
        pow(width(context), 3) /
        pow(standard(context), 3);
  }

  static double sizeByW2(BuildContext context, double size) {
    return borderPaddingScaleRatioForTablet(context) *
        size *
        pow(width(context), 2) /
        pow(standard(context), 2);
  }

  static double size(BuildContext context, double size) {
    return sizeScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));

  }

  static double size2(BuildContext context, double size) {
    return sizeScaleRatioForTablet2(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));
  }



  static double barSize(BuildContext context, double size) {
    return barSizeScaleRatioForTablet(context) *
        size *
        width(context) /
        standard(context);
  }

  static double barSize2(BuildContext context, double size) {
    return barSizeScaleRatioForTablet2(context) *
        size *
        width(context) /
        standard(context);
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double standard(BuildContext context) {
    return isTablet(context) ? 1024 : 428;
  }

  static double fontScaleRatioForTablet(BuildContext context) {
    return isTablet(context) ? 1.5 : 1;
  }

  static double sizeScaleRatioForTablet(BuildContext context) {
    return isTablet(context) ? 1.5 : 1;
  }

  static double sizeScaleRatioForTablet2(BuildContext context) {
    return isTablet(context) ? 1.2 : 1;
  }

  static double barSizeScaleRatioForTablet(BuildContext context) {
    return isTablet(context) ? 1.5 : 1;
  }

  static double barSizeScaleRatioForTablet2(BuildContext context) {
    return isTablet(context) ? 2.5: 1;
  }

  static double borderPaddingScaleRatioForTablet(BuildContext context) {
    return isTablet(context) ? 3 : 1;
  }

  static double paddingScaleRatioForTablet(BuildContext context) {
    return isTablet(context) ? 2 : 1;
  }

  static bool isTablet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var diagonal =
    sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }
}