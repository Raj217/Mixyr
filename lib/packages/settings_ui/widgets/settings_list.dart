import 'package:flutter/material.dart';
import 'settings_section.dart';

class SettingsList extends StatelessWidget {
  final List<SettingsSection> sections;
  final double gap;
  final Widget? leading;
  const SettingsList(
      {Key? key, this.leading, required this.sections, required this.gap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return (index == 0 && leading != null)
            ? leading!
            : sections[index - (leading == null ? 0 : 1)];
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: gap);
      },
      itemCount: sections.length + (leading == null ? 0 : 1),
    );
  }
}
