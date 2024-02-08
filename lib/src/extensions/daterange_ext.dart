import 'package:flutter/material.dart';
import 'package:ac_ranges/ac_ranges.dart' as acr;

extension DateRangeExt on acr.DateRange {

  DateTimeRange asDateTimeRange() => DateTimeRange(start: first, end: last);

}