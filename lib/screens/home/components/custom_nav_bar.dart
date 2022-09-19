import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/widgets/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:mixyr/widgets/custom_navigation_bar/custom_navigation_bar_item.dart';

class CustomNavBar extends StatefulWidget {
  final void Function(int)? onPageChange;
  final double height;
  const CustomNavBar(
      {Key? key, this.onPageChange, this.height = kDefaultIconSize})
      : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _currentlySelectedScreen = 0;
  CustomNavigationBarItem _getNavBarItem(
      {required IconData icon,
      required IconData selectedIcon,
      required String title}) {
    return CustomNavigationBarItem(
      selectedIcon: Icon(
        selectedIcon,
      ),
      icon: Icon(
        icon,
      ),
      selectedTitle: Text(
        title,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 10, color: kGreyLight, fontWeight: FontWeight.w800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      iconSize: widget.height,
      borderRadius: const Radius.circular(15),
      currentIndex: _currentlySelectedScreen,
      items: [
        _getNavBarItem(
            icon: Icons.home_outlined, selectedIcon: Icons.home, title: "Home"),
        _getNavBarItem(
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            title: "Explore"),
        _getNavBarItem(
            icon: Icons.library_music_outlined,
            selectedIcon: Icons.library_music,
            title: "Library"),
      ],
      onTap: (int index) {
        setState(() {
          _currentlySelectedScreen = index;
        });
        widget.onPageChange ?? (index);
      },
    );
  }
}
