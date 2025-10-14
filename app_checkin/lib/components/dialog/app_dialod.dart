import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> showChildWidgetBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    double? height,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.white,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder: (context) {
        return Container(
          height: height,
          padding: const EdgeInsets.all(16),
          child: child,
        );
      },
    );
  }

  static Future<T?> showChildModalWidget<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    ShapeBorder? shape,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (context) {
        return Dialog(
          shape:
              shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: child,
        );
      },
    );
  }

  static void closeDialog(BuildContext context, [dynamic result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }

  static void closeBottomSheet(BuildContext context, [dynamic result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }
}
