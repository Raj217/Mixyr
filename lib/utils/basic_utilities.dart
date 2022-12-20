import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixyr/utils/proxy_handler.dart';
import 'package:palette_generator/palette_generator.dart';

import '../config/configurations/paths.dart';
import 'package:http/http.dart' as http;
import 'package:external_path/external_path.dart';

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

Future<String> getLyrics({required String songName, String? artist}) async {
  if (songName.contains('(')) {
    songName = songName.substring(0, songName.indexOf('('));
  }
  final String query =
      'http://www.google.com/search?q=${songName.replaceAll(' ', '+').replaceAll('|', '')}${(artist ?? '').replaceAll(' ', '+').replaceAll('|', '')}+lyrics';
  print(query);
  var res = await http.get(Uri.parse(query));
  if (res.statusCode >= 200 && res.statusCode < 300) {
    var doc = parse(res.body);
    String data =
        doc.outerHtml.substring(doc.outerHtml.indexOf('BNeawe tAd8D AP7Wnd'));
    return data;
  }
  return '';
}

Duration parseDuration(String time) {
  if (time.isEmpty || time[0] != 'P') {
    return Duration.zero;
  }
  int t = 0;
  int weeks = 0, days = 0, hours = 0, mins = 0, secs = 0;
  bool isTimeDesignatorOn = false;
  for (int i = 1; i < time.length; i++) {
    if (time[i] == "W") {
      weeks = t;
      t = 0;
    } else if (time[i] == "D") {
      days = t;
      t = 0;
    } else if (time[i] == "T") {
      isTimeDesignatorOn = true;
    } else if (time[i] == "H") {
      hours = t;
      t = 0;
    } else if (time[i] == "M" && isTimeDesignatorOn) {
      mins = t;
      t = 0;
    } else if (time[i] == "S") {
      secs = t;
      t = 0;
    } else {
      t = t * 10 + int.parse(time[i]);
    }
  }
  return Duration(
      days: weeks * 7 + days, hours: hours, minutes: mins, seconds: secs);
}
