import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: kBlack,
  scaffoldBackgroundColor: kBlack,
  fontFamily: 'Lato',
  colorScheme: ColorScheme.fromSwatch(
          primarySwatch: kPrimarySwatch, brightness: Brightness.dark)
      .copyWith(secondary: kWhite),
  textTheme: const TextTheme().apply(bodyColor: kWhite, displayColor: kWhite),
  focusColor: kWhite,
  shadowColor: kWhite,
  disabledColor: kGreyLight,
);
