import 'package:flutter/services.dart';

extension ComparisonExtension on Size {
  bool isAnyDimensionSmallerThan(Size other) {
    return width < other.width || height < other.height;
  }
}
