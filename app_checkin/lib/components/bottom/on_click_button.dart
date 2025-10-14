import 'package:flutter/material.dart';

class OnClickButton extends StatelessWidget {
  final VoidCallback onClick;
  final Widget child;

  const OnClickButton({super.key, required this.onClick, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
