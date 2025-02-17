import 'package:flutter/material.dart';

class AcLoader extends StatelessWidget {
  final String? title;

  const AcLoader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (title != null) Text(title!),
      ],
    );
  }
}
