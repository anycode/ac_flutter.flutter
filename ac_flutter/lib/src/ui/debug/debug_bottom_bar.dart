import 'package:flutter/material.dart';

class DebugBottomBar extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;

  const DebugBottomBar({super.key, this.onShare, this.onCopy, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Sdílet', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'Do schránky', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Smazat', backgroundColor: Colors.white),
          ],
          onTap: (idx) {
            switch (idx) {
              case 0:
                onShare?.call();
                break;
              case 1:
                onCopy?.call();
                break;
              case 2:
                onDelete?.call();
                break;
            }
          },
        ),
      ),
    );
  }
}
