import 'package:ac_dart/ac_dart.dart';
import 'package:flutter/material.dart';

import 'ac_debug_view.dart';

class AcTabbedDebugsView extends StatefulWidget {
  final List<DebugLogger> debugLoggers;

  const AcTabbedDebugsView({super.key, required this.debugLoggers});

  @override
  State<AcTabbedDebugsView> createState() => _AcTabbedDebugsViewState();
}

class _AcTabbedDebugsViewState extends State<AcTabbedDebugsView> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    if (widget.debugLoggers.length > 1) {
      tabController = TabController(length: widget.debugLoggers.length, vsync: this);
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.debugLoggers.length == 1
        ? AcDebugView(debugLogger: widget.debugLoggers[0])
        : Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TabBar(
                tabs: widget.debugLoggers.map((ds) => Tab(text: ds.name)).toList(),
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.debugLoggers.map((ds) => AcDebugView(debugLogger: ds)).toList(),
                ),
              ),
            ],
          );
  }
}
