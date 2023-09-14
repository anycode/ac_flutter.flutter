import 'package:ac_dart/ac_dart.dart';
import 'package:flutter/material.dart';

import 'debug_view.dart';

class TabbedDebugsView extends StatefulWidget {
  final List<DebugLogger> debugLoggers;

  const TabbedDebugsView({super.key, required this.debugLoggers});

  @override
  State<TabbedDebugsView> createState() => _TabbedDebugsViewState();
}

class _TabbedDebugsViewState extends State<TabbedDebugsView> with SingleTickerProviderStateMixin {
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
        ? DebugView(debugLogger: widget.debugLoggers[0])
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
                  children: widget.debugLoggers.map((ds) => DebugView(debugLogger: ds)).toList(),
                ),
              ),
            ],
          );
  }
}
