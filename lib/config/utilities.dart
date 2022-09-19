import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

import 'paths.dart';

// -------------------------- System related --------------------------
void setBottomNavBarColor({required Color color}) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: color));
}

// -------------------------- Verifiers --------------------------
bool googleMailVerifier(String? email) {
  if (email != null &&
      email.length > 10 &&
      email.substring(email.length - 10) == "@gmail.com") {
    return true;
  }
  return false;
}

// -------------------------- necessary functions --------------------------
Future<Color?> dominantColor({required Image img}) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    img.image,
  );
  return paletteGenerator.dominantColor?.color;
}

/// Range: [lowerBound, upperBound)
int randomNumberGenerator({int lowerBound = 1, int upperBound = 6}) {
  // TODO: Test this
  return lowerBound + Random().nextInt(upperBound - lowerBound);
}

String getGradientBackgroundImage({int backgroundNumber = 1}) {
  return '${paths[Paths.gradientImage]!}$backgroundNumber.jpg';
}
