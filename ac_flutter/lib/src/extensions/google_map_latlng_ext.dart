import 'package:ac_dart/ac_dart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension GoogleMapLatLngExt on LatLng {

  /// Parse [String] input into [LatLng] object
  /// Input can be decimal degrees or composed degrees where minutes can be decimal or composed
  /// Latitude and longitude can be in any order and delimited by any separator (space, coma, colon, semicolon)
  /// other than digit, dot (decimal point) and 'N','S','E','W'
  /// Valid inputs are e.g.
  /// * 50.763849890N 16.3423545E
  /// * 50deg 30min 5.64324sec N, 16deg 12.3456min E
  /// * 50° 30' 5.65434" N, 16° 12' 8.2324235" E
  /// or any combination, e.g.
  /// * 50.763849890N;16deg 12.3456' E
  /// * 50° 30' 5.65434" N, 16deg 12.3456min E
  static LatLng? parse(String? input) {
    if(input == null) {
      return null;
    }
    // a-z non capturing groups
    // 1-6 capturing groups
    //                       deg                                   min                               sec
    //                         a  1   b       b 1c       c  2   2d        de     3   f       f 3g       g 4   4h        hi     5   j       j 5k       ki e a   6      6
    final llRegex = RegExp(r'''(?:(\d+(?:\.\d+)?)(?:°|deg)?|(\d+)(?:°|deg )(?:\s*(\d+(?:\.\d+)?)(?:'|min)|(\d+)(?:'|min )(?:\s*(\d+(?:\.\d+)?)(?:"|sec))?)?)\s*([NSEW])''');
    if(llRegex.hasMatch(input)) {
      var lat = 0.0;
      var lng = 0.0;
      llRegex.allMatches(input).forEach((match) {
        final ll = match[1] != null
            ? double.parse(match[1]!)  // decimal degrees
            : int.parse(match[2]!) // degrees with optional minutes and seconds
            + (match[3] != null
                ? double.parse(match[3]!) / 60 // decimal minutes
                : int.parse(match[4]!) / 60    // minutes with optional seconds
                + (match[5] != null
                    ? double.parse(match[5]!) / 3600 // decimal seconds
                    : 0.0));
        switch(match[6]!) {
          case 'N': lat = ll; break;
          case 'S': lat = -ll; break;
          case 'E': lng = ll; break;
          case 'W': lng = -ll; break;
          default: break; // should not get here
        }
      });
      return LatLng(lat, lng);
    } else {
      return null;
    }
  }

  String format() {
    return '${formatLatitude(latitude)} ${formatLongitude(longitude)}';
  }

}
