import 'dart:ui';

import 'package:reminder_app/ui/colors.dart';

enum ColorTaskType {
  blue,
  pink,
  yellow,
}

extension ToType on String {
  Color toColor() {
    if (this == ColorTaskType.pink.name) {
      return ColorPalette.pinkClr;
    }
    if (this == ColorTaskType.yellow.name) {
      return ColorPalette.yellowClr;
    }
    if (this == ColorTaskType.blue.name) {
      return ColorPalette.primaryClr;
    }
    throw Exception('color is not valid.');
  }
}
