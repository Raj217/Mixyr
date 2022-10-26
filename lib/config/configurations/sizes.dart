import 'package:flutter/cupertino.dart';

double responsiveHeight(double height, BuildContext context) =>
    height * MediaQuery.of(context).size.height / 756;
double responsiveWidth(double width, BuildContext context) =>
    width * MediaQuery.of(context).size.width / 360;

double relativeHeight(double percentage, BuildContext context) =>
    MediaQuery.of(context).size.height * percentage;
double relativeWidth(double percentage, BuildContext context) =>
    MediaQuery.of(context).size.width * percentage;

/// Limits the maximum range of the relative height to be calculated to [maxLimitPercentage]
double relativeLimitedHeightWithMargin(
        {double maxLimitPercentage = 1,
        required double percentage,
        double marginPercentage = 0,
        required BuildContext context}) =>
    MediaQuery.of(context).size.height *
    _relativeLimitedCalculator(
        maxLimitPercentage: maxLimitPercentage,
        percentage: percentage,
        marginPercentage: marginPercentage);

/// Limits the maximum range of the relative width to be calculated to [maxLimitPercentage]
double relativeLimitedWidthWithMargin(
        {double maxLimitPercentage = 1,
        required double percentage,
        double marginPercentage = 0,
        required BuildContext context}) =>
    MediaQuery.of(context).size.width *
    _relativeLimitedCalculator(
      percentage: percentage,
      maxLimitPercentage: maxLimitPercentage,
      marginPercentage: marginPercentage,
    );

/// Limits the maximum range of the relative dimension to be calculated to [maxLimitPercentage]
double _relativeLimitedCalculator(
        {required double maxLimitPercentage,
        required double percentage,
        required double marginPercentage}) =>
    (marginPercentage + percentage * (maxLimitPercentage - marginPercentage));

const double kDefaultIconSize = 24;
const double kDefaultButtonHeight = 40;
const double kDefaultButtonWidth = 200;

const Duration kDefaultAnimDuration = Duration(milliseconds: 700);
