import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';

class LyricsBox extends StatelessWidget {
  final String lyrics;
  final Color color;
  const LyricsBox({Key? key, required this.lyrics, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: color,
      child: Text(lyrics, style: largeText),
    );
  }
}
