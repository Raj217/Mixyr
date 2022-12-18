import 'package:flutter/material.dart';

class UpNextCard extends StatelessWidget {
  final Image thumbnail;
  final String title;
  final String artist;
  final Duration duration;
  const UpNextCard(
      {Key? key,
      required this.thumbnail,
      required this.title,
      required this.artist,
      required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        thumbnail,
        Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(artist),
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
