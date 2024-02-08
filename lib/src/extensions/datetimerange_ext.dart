import 'package:flutter/material.dart';
import 'package:ac_ranges/ac_ranges.dart' as acr;

extension DateTimeRangeExt on DateTimeRange {

  acr.DateRange asDateRange() {
    return acr.DateRange(start, end, startInclusive: true, endInclusive: true);
  }

}
