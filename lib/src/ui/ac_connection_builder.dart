import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';

import 'ac_loader.dart';
import 'ac_widget_builder.dart';

class AcConnectionBuilder extends StatelessWidget {
  final TypedWidgetBuilder<ConnectivityStatus?> builder;
  final TypedWidgetBuilder<ConnectivityStatus?> errorBuilder;
  final WidgetBuilder? loadingBuilder;

  const AcConnectionBuilder({required this.builder, required this.errorBuilder, this.loadingBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (BuildContext context, bool? isConnected, ConnectivityStatus? status) {
        return switch(isConnected) {
          true => builder(context, status),
          false => errorBuilder(context, status),
          _ => loadingBuilder?.call(context) ?? const AcLoader(),
        };
      },
    );
  }
}
