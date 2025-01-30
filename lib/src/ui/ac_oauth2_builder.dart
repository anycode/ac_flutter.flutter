import 'package:ac_api_client/ac_api_client.dart';
import 'package:flutter/material.dart';

import 'ac_loading_builder.dart';
import 'ac_widget_builder.dart';

class AcOAuth2Builder extends StatelessWidget {
  final TypedWidgetBuilder<Credentials> authorizedBuilder;
  final WidgetBuilder unauthorizedBuilder;
  final WidgetBuilder? loadingBuilder;
  final TypedWidgetBuilder? errorBuilder;
  final Stream<Credentials?> oAuthCredentialsStream;

  const AcOAuth2Builder({
    required this.oAuthCredentialsStream,
    required this.authorizedBuilder,
    required this.unauthorizedBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AcLoadingBuilder<Credentials>(
      stream: oAuthCredentialsStream,
      builder: authorizedBuilder,
      emptyBuilder: unauthorizedBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
