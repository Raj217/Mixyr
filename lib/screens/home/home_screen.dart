import 'package:flutter/material.dart';
import 'package:mixyr/screens/home/widgets/custom_app_bar.dart';
import 'package:mixyr/screens/home/screens/explore_page.dart';
import 'package:mixyr/screens/home/screens/home_page.dart';
import 'package:mixyr/screens/home/screens/library_page.dart';

import 'widgets/custom_nav_bar.dart';
import 'widgets/miniplayer.dart';
import 'package:mixyr/config/config.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "Home Screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const List<Widget> pageMap = [
    HomePage(),
    ExplorePage(),
    LibraryPage()
  ];
  int _currentlySelectedScreen = 0;
  double height = kDefaultIconSize;
  ValueNotifier<double> miniPlayerHeight = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsiveWidth(8, context)),
                  sliver: const CustomAppBar(),
                ),
                pageMap[_currentlySelectedScreen],
              ],
            ),
            Miniplayer(
              height: 80,
              miniPlayerPercentageNotifier: miniPlayerHeight,
            ),
            const SizedBox(height: 80, child: CustomNavBar()),
          ],
        ),
      ),
    );
  }
}
