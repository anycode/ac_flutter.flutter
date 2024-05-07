import 'package:ac_dart/ac_dart.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'debug_bottom_bar.dart';

class DebugView extends StatefulWidget {
  final DebugLogger debugLogger;

  const DebugView({super.key, required this.debugLogger});

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: FutureBuilder(
              future: widget.debugLogger.output.content,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Text(snapshot.data![index], softWrap: false),
                  );
                } else {
                  return Container();
                }
              }),
        ),
        DebugBottomBar(
          onShare: () async => Share.shareXFiles(widget.debugLogger.output.xFiles),
          onCopy: () async => FlutterClipboard.copy((await widget.debugLogger.output.content).toString()),
          onDelete: () async {
            widget.debugLogger.output.clearLog();
            setState(() {});
          },
        ),
      ],
    );
  }
}
