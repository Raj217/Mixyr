import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';

ThemeData lightTheme = ThemeData(
    primaryColor: kWhite,
    scaffoldBackgroundColor: kWhite,
    fontFamily: 'Lato',
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: kPrimarySwatch, brightness: Brightness.light)
        .copyWith(secondary: kBlack),
    textTheme: const TextTheme().apply(displayColor: kBlack, bodyColor: kBlack),
    focusColor: kBlack,
    disabledColor: kGreyLight,
    shadowColor: kBlack);
