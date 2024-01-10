import 'package:flutter/material.dart';

extension AlignmentExt on Alignment {
  bool get isLeft => [Alignment.topLeft, Alignment.centerLeft, Alignment.bottomLeft].contains(this);

  bool get isHCenter => [Alignment.topCenter, Alignment.center, Alignment.bottomCenter].contains(this);

  bool get isRight => [Alignment.topRight, Alignment.centerRight, Alignment.bottomRight].contains(this);

  bool get isTop => [Alignment.topLeft, Alignment.topCenter, Alignment.topRight].contains(this);

  bool get isVCenter => [Alignment.centerLeft, Alignment.center, Alignment.centerRight].contains(this);

  bool get isBottom => [Alignment.bottomLeft, Alignment.bottomCenter, Alignment.bottomRight].contains(this);
}
