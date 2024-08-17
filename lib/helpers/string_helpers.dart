import 'dart:math';
import 'package:optima_soft/app_config/app_config.dart';
import 'package:optima_soft/helpers/platform_helper.dart';

class StringHelper {
  static bool isEmptyOrNull(String? string) {
    return string == '' || string == null;
  }

  static double generateProportionateFontSize(double size, {double? width}) {
    double constraintWidth = width ?? PlatformHelper.screenWidth;
    size = max(MIN_DYNAMIC_FONT_SIZE, size);
    int denominator = TABLETS_START_SCREEN_RANGE > constraintWidth ? 400 : 470;
    return (size * constraintWidth) / denominator;
  }

  // static String pictureSideToString(PictureSide side) {
  //   return side.toString().split(".").last;
  // }

  // static PictureSide stringToPictureSide(String picture) {
  //   return PictureSide.values
  //       .firstWhere((PictureSide side) => pictureSideToString(side) == picture);
  // }
}

extension StringExtension on String {
  String get toSentenceCase =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get toSentenceCaseAll => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toSentenceCase)
      .join(" ");
}
