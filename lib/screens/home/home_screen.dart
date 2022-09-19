import 'package:flutter/material.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/screens/home/components/custom_app_bar.dart';
import 'package:mixyr/screens/home/components/custom_nav_bar.dart';
import 'package:mixyr/screens/home/screens/explore_page.dart';
import 'package:mixyr/screens/home/screens/home_page.dart';
import 'package:mixyr/screens/home/screens/library_page.dart';

import 'components/player.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "Home Screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Map<int, Widget> pageMap = {
    0: HomePage(),
    1: ExplorePage(),
    2: LibraryPage()
  };
  int _currentlySelectedScreen = 0;
  double height = kDefaultIconSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Player(
          height: 2.4 * height,
          appBar: Padding(
            padding: EdgeInsets.all(responsiveWidth(15, context)),
            child: const CustomAppBar(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: RepaintBoundary(
                  child: pageMap[_currentlySelectedScreen]!,
                ),
              ),
            ],
          ),
          navBar: CustomNavBar(
            height: height,
            onPageChange: (int index) {
              setState(() {
                _currentlySelectedScreen = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
