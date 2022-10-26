import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:mixyr/config/config.dart';

class ToggleButton extends StatelessWidget {
  final bool isSongMode;
  final void Function(bool) onChanged;
  final String firstText;
  final String secondText;
  final IconData firstIcon;
  final IconData secondIcon;
  const ToggleButton(
      {Key? key,
      required this.isSongMode,
      required this.onChanged,
      required this.firstText,
      required this.secondText,
      required this.firstIcon,
      required this.secondIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch.dual(
      current: isSongMode,
      first: true,
      second: false,
      borderWidth: 1,
      height: 30,
      onChanged: onChanged,
      textBuilder: (isSongMode) => isSongMode == true
          ? ToggleCardText(text: firstText)
          : ToggleCardText(text: secondText),
      iconBuilder: (isSongMode) => isSongMode == true
          ? ToggleCardIcon(icon: firstIcon)
          : ToggleCardIcon(icon: secondIcon),
    );
  }
}

class ToggleCardText extends StatelessWidget {
  final String text;
  const ToggleCardText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ToggleCardIcon extends StatelessWidget {
  final IconData icon;
  const ToggleCardIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: kDefaultIconSize - 10,
    );
  }
}
