
import 'package:flutter/widgets.dart';

/// Typed widget builder for passing data of type T back to the caller
typedef TypedWidgetBuilder<T> = Widget Function(BuildContext context, T data);

/// Widget builder with optional [child] (might be some static widget prepared before calling [builder])
typedef AcWidgetBuilder = Widget Function(BuildContext context, Widget? child);

/// Widget builder with an optional [data] of type T and a [child] (might be some static widget prepared before calling [builder])
typedef AcTypedWidgetBuilder<T> = Widget Function(BuildContext context, T? data, Widget? child);
