import 'package:flutter/material.dart';
import 'package:ranges/ranges.dart' as ranges;

extension DateTimeRangeExt on DateTimeRange {

  ranges.DateRange asDateRange() {
    return ranges.DateRange(start, end, startInclusive: true, endInclusive: true);
  }

}
