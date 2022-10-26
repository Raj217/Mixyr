import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final void Function() onTap;
  final double gap;
  final Widget? leadingIcon;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double? height;
  final double? width;
  final double? relHeight;
  final double? relWidth;
  final Duration animDuration;
  const RoundedButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.gap = 6,
      this.style,
      this.leadingIcon,
      this.borderRadius = 10,
      this.backgroundColor = kWhite,
      this.textColor = kBlack,
      this.fontSize = 15,
      this.height,
      this.width,
      this.relHeight,
      this.relWidth,
      this.animDuration = const Duration(milliseconds: 700)})
      : assert(!(height != null && relHeight != null),
            'either height or relHeight can be provided'),
        assert(!(width != null && relWidth != null),
            'either width or relWidth can be provided'),
        assert(relHeight == null || (0 < relHeight && relHeight <= 1),
            'relHeight must be in the range (0,1]'),
        assert(relWidth == null || (0 < relWidth && relWidth <= 1),
            'relWidth must be in the range (0,1]'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: animDuration,
          height: relHeight != null
              ? relativeHeight(relHeight!, context)
              : responsiveHeight(height ?? kDefaultButtonHeight, context),
          width: relWidth != null
              ? relativeWidth(relWidth!, context)
              : responsiveWidth(width ?? kDefaultButtonWidth, context),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon ?? const SizedBox.shrink(),
              SizedBox(
                  width:
                      leadingIcon != null ? responsiveWidth(gap, context) : 0),
              Text(
                title,
                style: style ??
                    TextStyle(
                      color: textColor,
                      fontSize: responsiveWidth(fontSize, context),
                    ),
              ),
            ],
          )),
    );
  }
}
