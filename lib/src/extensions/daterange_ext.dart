import 'package:flutter/material.dart';
import 'package:ranges/ranges.dart' as ranges;

extension DateRangeExt on ranges.DateRange {

  DateTimeRange asDateTimeRange() => DateTimeRange(start: first, end: last);

}