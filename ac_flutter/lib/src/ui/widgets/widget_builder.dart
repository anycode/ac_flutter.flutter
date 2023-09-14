
import 'package:flutter/widgets.dart';

/// Widget builder with optional [child] (might be some static widget prepared before calling [builder])
typedef AcWidgetBuilder = Widget Function(BuildContext context, Widget? child);
