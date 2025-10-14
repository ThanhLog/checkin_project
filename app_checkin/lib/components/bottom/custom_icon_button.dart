import 'package:app_checkin/components/bottom/on_click_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.size = 24,
    this.bgColor = Colors.transparent,
    this.iconColos = Colors.black,
  });

  final String icon;
  final VoidCallback onClick;
  final double? size;
  final Color? bgColor;
  final Color? iconColos;
  @override
  Widget build(BuildContext context) {
    return OnClickButton(
      onClick: onClick,
      child: Container(
        padding: bgColor != null ? EdgeInsets.all(5) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: SvgPicture.asset(
          icon,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(iconColos!, BlendMode.srcIn),
        ),
      ),
    );
  }
}
