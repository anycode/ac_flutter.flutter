import 'package:ac_flutter/ac_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'ac_debug_bottom_bar.dart';

class AcDebugView extends StatelessWidget {
  final DebugLogger debugLogger;

  const AcDebugView({super.key, required this.debugLogger});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _AcDebugViewWeb(debugLogger) : _AcDebugViewNative(debugLogger: debugLogger);
  }
}

class _AcDebugViewNative extends StatefulWidget {
  final DebugLogger debugLogger;

  const _AcDebugViewNative({super.key, required this.debugLogger});

  @override
  State<_AcDebugViewNative> createState() => _AcDebugViewNativeState();
}

class _AcDebugViewNativeState extends State<_AcDebugViewNative> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        if (_controller.hasClients) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
          //_controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 333), curve: Curves.easeIn);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: AcLoadingBuilder(
              future: widget.debugLogger.output!.content,
              builder: (context, data) {
                return ListView.builder(
                  controller: _controller,
                  itemCount: data.length,
                  itemBuilder: (context, index) => Text(data[index], softWrap: false),
                );
              }),
        ),
        AcDebugBottomBar(
          onShare: () async => Share.shareXFiles(widget.debugLogger.output!.xFiles),
          onCopy: () async => FlutterClipboard.copy((await widget.debugLogger.output!.content).toString()),
          onDelete: () async {
            widget.debugLogger.output!.clearLog();
            setState(() {});
          },
          logName: widget.debugLogger.name,
        ),
      ],
    );
  }
}

class _AcDebugViewWeb extends StatelessWidget {
  final DebugLogger debugLogger;

  const _AcDebugViewWeb(this.debugLogger);

  @override
  Widget build(BuildContext context) {
    return Text('Not supported on web, see browser debugger console');
  }
}
