import 'package:flutter/widgets.dart';

class LayoutConstants {
  const LayoutConstants._();

  static EdgeInsets pagePadding(
    BuildContext context, {
    bool includeTop = true,
    bool includeBottom = true,
    double horizontalScale = 1,
    double verticalScale = 1,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    double horizontal = 24;
    double vertical = 28;

    if (width < 360) {
      horizontal = 16;
      vertical = 20;
    } else if (width < 400) {
      horizontal = 18;
      vertical = 22;
    } else if (width < 480) {
      horizontal = 20;
      vertical = 24;
    }

    horizontal *= horizontalScale;
    vertical *= verticalScale;

    return EdgeInsets.only(
      left: horizontal,
      right: horizontal,
      top: includeTop ? vertical : 0,
      bottom: includeBottom ? vertical : 0,
    );
  }
}
