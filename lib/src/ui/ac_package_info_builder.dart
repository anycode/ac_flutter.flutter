import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'ac_loader.dart';
import 'ac_loading_builder.dart';
import 'ac_widget_builder.dart';

class AcPackageInfoBuilder extends StatelessWidget {
  final TypedWidgetBuilder<PackageInfo> builder;
  final WidgetBuilder? loadingBuilder;

  const AcPackageInfoBuilder({required this.builder, this.loadingBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return AcLoadingBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      loadingBuilder: loadingBuilder,
      builder: builder,
    );
  }
}
