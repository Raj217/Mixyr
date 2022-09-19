import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';
import 'package:mixyr/config/sizes.dart';

class ExpandedButton extends StatelessWidget {
  final void Function() onTap;
  final IconData? icon;
  final Widget? widget;
  final IconData backgroundShape;
  final Color iconColor;
  final Color backgroundColor;
  final double foregroundObjectSize;

  /// Note that the [extraBackgroundSize] is the extra amount i.e. the final size
  /// of the background shape will be [foregroundObjectSize]+[extraBackgroundSize]
  final double extraBackgroundSize;
  const ExpandedButton(
      {Key? key,
      required this.onTap,
      this.icon,
      this.widget,
      this.backgroundShape = Icons.circle,
      this.iconColor = kWhite,
      this.backgroundColor = Colors.transparent,
      this.foregroundObjectSize = kDefaultIconSize,
      this.extraBackgroundSize = 30})
      : assert(icon != null || widget != null,
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
          widget != null
              ? widget!
              : Icon(
                  icon!,
                  size: foregroundObjectSize,
                  color: iconColor,
                ),
        ],
      ),
    );
  }
}
