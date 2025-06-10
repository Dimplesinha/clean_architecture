import 'package:flutter/material.dart';
import 'package:icon_animated/icon_animated.dart';

enum CustomSnackBarType {
  success,
  fail,
  alert,
}

class CustomSnackBar extends StatefulWidget {
  final String message;
  final CustomSnackBarType snackBarType;
  final bool isSnackBarShown;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color iconColor;
  final TextStyle? labelTextStyle;
  final int? maxLines;

  const CustomSnackBar({
    super.key,
    required this.message,
    required this.snackBarType,
    required this.isSnackBarShown,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.labelTextStyle,
    this.maxLines,
  });

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  bool _fadeAnimationStart = false;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!disposed) {
        setState(() {
          _fadeAnimationStart = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: widget.isSnackBarShown ? 10.0 : -100.0,
      left: 20.0,
      right: 20.0,
      child: InkWell(
        onTap: widget.onPressed,
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: widget.backgroundColor ?? _getBackgroundColor(widget.snackBarType),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 400),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: IconAnimated(
                      color: _fadeAnimationStart ? widget.iconColor : widget.backgroundColor,
                      active: true,
                      size: 40,
                      iconType: _getIconType(widget.snackBarType),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(left: _fadeAnimationStart ? 0 : 10),
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: _fadeAnimationStart ? 1.0 : 0.0,
                      child: Text(
                        widget.message,
                        overflow: TextOverflow.ellipsis,
                        maxLines: widget.maxLines ?? 3,
                        style: widget.labelTextStyle ?? const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Color _getBackgroundColor(CustomSnackBarType type) {
    switch (type) {
      case CustomSnackBarType.success:
        return Colors.green;
      case CustomSnackBarType.fail:
        return Colors.red;
      case CustomSnackBarType.alert:
      default:
        return Colors.black;
    }
  }

  IconType _getIconType(CustomSnackBarType type) {
    switch (type) {
      case CustomSnackBarType.success:
        return IconType.check;
      case CustomSnackBarType.fail:
        return IconType.fail;
      case CustomSnackBarType.alert:
      default:
        return IconType.alert;
    }
  }
}
