import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';

class ExpandedButton extends StatelessWidget {
  final void Function() onTap;
  final IconData? icon;
  final Widget? child;
  final IconData backgroundShape;
  final Color? iconColor;
  final Color backgroundColor;
  final double foregroundObjectSize;

  /// Note that the [extraBackgroundSize] is the extra amount i.e. the final size
  /// of the background shape will be [foregroundObjectSize]+[extraBackgroundSize]
  final double extraBackgroundSize;
  const ExpandedButton(
      {Key? key,
      required this.onTap,
      this.icon,
      this.child,
      this.backgroundShape = Icons.circle,
      this.iconColor,
      this.backgroundColor = Colors.transparent,
      this.foregroundObjectSize = kDefaultIconSize,
      this.extraBackgroundSize = 30})
      : assert(icon != null || child != null,
            "either icon or widget must be provided."),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.circle,
              size: foregroundObjectSize +
                  responsiveWidth(extraBackgroundSize, context),
              color: backgroundColor),
          child != null
              ? child!
              : Icon(
                  icon!,
                  size: foregroundObjectSize,
                  color: iconColor ?? Theme.of(context).focusColor,
                ),
        ],
      ),
    );
  }
}
