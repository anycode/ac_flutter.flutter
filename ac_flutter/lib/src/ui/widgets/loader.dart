import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String? title;

  const Loader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        if (title != null) Text(title!),
      ],
    );
  }
}
