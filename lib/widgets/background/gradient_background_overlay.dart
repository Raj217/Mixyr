import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';
import 'package:mixyr/utils/basic_utilities.dart';

class GradientBackgroundOverlay extends StatelessWidget {
  final Widget child;
  final double backgroundHeight;
  final int backgroundNumber;

  const GradientBackgroundOverlay(
      {Key? key,
      required this.child,
      this.backgroundHeight = 0.75,
      this.backgroundNumber = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          getGradientBackgroundImage(backgroundNumber: backgroundNumber),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: relativeHeight(1 - backgroundHeight, context)),
          child: Container(
            height: relativeHeight(backgroundHeight, context),
            width: relativeWidth(1, context),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 80,
                  blurRadius: 100,
                  color: Theme.of(context).primaryColor,
                  offset: const Offset(0, -10),
                )
              ],
            ),
          ),
        ),
        child
      ],
    );
  }
}
