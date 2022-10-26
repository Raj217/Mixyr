import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';

class SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool showToggleButton;
  final void Function(bool)? onToggleButtonChange;
  final bool showTrailingButton;
  final bool initialToggleValue;
  final IconData trailing;
  final Color _iconColor;
  final Color _trailingIconColor;
  final double iconSize;
  final double gap;

  SettingsTile(
      {Key? key,
      required this.icon,
      required this.title,
      this.showToggleButton = false,
      this.onToggleButtonChange,
      this.trailing = Icons.chevron_right,
      this.initialToggleValue = false,
      Color? iconColor,
      Color? trailingIconColor,
      this.showTrailingButton = true,
      this.iconSize = kDefaultIconSize,
      this.gap = 10})
      : _iconColor = iconColor ?? kWhite,
        _trailingIconColor = trailingIconColor ?? kGreyLight,
        assert(!showToggleButton || onToggleButtonChange != null,
            'if toggle button is true, onToggleButtonChange cannot be null'),
        super(key: key);

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool? toggleButtonValue;

  @override
  Widget build(BuildContext context) {
    toggleButtonValue = toggleButtonValue ?? widget.initialToggleValue;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.gap, vertical: widget.gap / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: widget._iconColor,
                size: widget.iconSize,
              ),
              SizedBox(
                width: widget.gap,
              ),
              Text(widget.title)
            ],
          ),
          Row(
            children: [
              Visibility(
                visible: widget.showToggleButton,
                child: Switch(
                  value: toggleButtonValue!,
                  activeColor: kWhite,
                  onChanged: (val) {
                    setState(() {
                      toggleButtonValue = val;
                      widget.onToggleButtonChange!(val);
                    });
                  },
                ),
              ),
              Visibility(
                  visible: widget.showTrailingButton,
                  child: Icon(
                    widget.trailing,
                    size: widget.iconSize,
                    color: widget._trailingIconColor,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
