import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

import 'paths.dart';
import 'package:http/http.dart' as http;
// import 'package:web_scraper/web_scraper.dart';

// -------------------------- System related --------------------------
void setBottomNavBarColor({required Color color}) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: color));
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

String scrapeYoutubeAudioID({required String link}) {
  List<String> parts = link.split('v=');
  String audioID = '';
  if (parts.length > 1) {
    int indexOfSeparator = parts[1].indexOf('&');
    audioID =
        parts[1].substring(0, indexOfSeparator == -1 ? null : indexOfSeparator);
  } else {
    parts = link.split('/');
    audioID = parts[parts.length - 1];
  }
  return audioID;
}

dynamic getLyrics({required String songName, required String artist}) async {
  if (songName.contains('(')) {
    songName = songName.substring(0, songName.indexOf('('));
  }

  // final webScraper = WebScraper('https://google.com');
  // String query = 'search?q=' + songName.replaceAll(' ', '+') + '+lyrics';
  // if (await webScraper.loadWebPage(query)) {
  //   dynamic elements = webScraper.getElement('div', ['class']);
  //   print(elements);
  // }
}
