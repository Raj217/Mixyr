import 'package:flutter/material.dart';
import 'package:mixyr/config/configurations/palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final PageController pageController;
  final int count;
  static const double _dotSize = 7;
  const PageIndicator(
      {Key? key, required this.pageController, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: count,
      effect: WormEffect(
        dotWidth: _dotSize,
        dotHeight: _dotSize,
        dotColor: kGreyLight,
        paintStyle: PaintingStyle.stroke,
        activeDotColor: Theme.of(context).focusColor,
      ),
    );
  }
}
