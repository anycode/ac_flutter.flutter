import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

///
///  ColorConverter annotation
///  If the color is already of Color type return it, otherwise try to parse String.
///  e.g.
///  ```dart
///  @JsonKey(name: 'color')
///  @ColorConverter()
///  Color color;
///  ```
class ColorConverter implements JsonConverter<Color, Object> {
  const ColorConverter();

  @override
  Color fromJson(Object json) {
    if (json is Color) {
      return json;
    } else if (json is String) {
      if (json[0] == '#') json = json.substring(1);
      final value = int.parse(json, radix: 16);
      return Color(value);
    } else {
      throw Exception('Invalid input for Color');
    }
  }

  @override
  String toJson(Color color) {
    return '#${color.value.toRadixString(16)}';
  }
}

///
///  ColorListConverter annotation
///  If the color is already of Color type return it, otherwise try to parse String.
///  e.g.
///  ```dart
///  @JsonKey(name: 'colors')
///  @ColorsConverter()
///  List<Color> colors;
///  ```
class ColorListConverter implements JsonConverter<List<Color>, Object> {
  const ColorListConverter();

  @override
  List<Color> fromJson(Object json) {
    const converter = ColorConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<Color> colors) {
    const converter = ColorConverter();
    return colors.map((Color color) => converter.toJson(color)).toList();
  }
}
