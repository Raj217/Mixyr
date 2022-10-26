import 'package:flutter/material.dart';
import 'settings_tile.dart';
import 'package:mixyr/config/config.dart';

class SettingsSection extends StatelessWidget {
  final String name;
  final List<SettingsTile> tiles;
  final Color _color;
  final double gap;
  SettingsSection(
      {Key? key,
      required this.name,
      required this.tiles,
      Color? color,
      required this.gap})
      : _color = color ?? kGreyLight,
        super(key: key);
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
    children = [
      Text(
        name,
        style: TextStyle(color: _color, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: gap)
    ];
    for (int i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);
      children.add(
        SizedBox(
          height: gap,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
