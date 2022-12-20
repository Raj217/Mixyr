import 'package:flutter/material.dart';
import 'package:mixyr/screens/home/screens/search_page/search_page.dart';
import 'package:mixyr/screens/home/widgets/custom_app_bar.dart';
import 'package:mixyr/screens/home/screens/explore_page.dart';
import 'package:mixyr/screens/home/screens/home_page.dart';
import 'package:mixyr/screens/home/screens/library_page.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:provider/provider.dart';
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
    LibraryPage(),
  ];
  int _currentlySelectedScreen = 0;
  double height = kDefaultIconSize;
  ValueNotifier<double> miniPlayerHeight = ValueNotifier(0);
  String searchQuery = "";
  bool searchPage = false;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    searchQuery = Provider.of<YoutubeHandler>(context).query;
    if (searchQuery.isNotEmpty) {
      setState(() {
        _currentlySelectedScreen = -1;
        searchPage = true;
      });
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(8, context)),
                sliver: const CustomAppBar(),
              ),
              (searchQuery.isNotEmpty && searchPage == true)
                  ? SearchPage(
                      query: searchQuery, scrollController: scrollController)
                  : pageMap[_currentlySelectedScreen]
            ],
          ),
          Miniplayer(
            height: 80,
            miniPlayerPercentageNotifier: miniPlayerHeight,
          ),
          SizedBox(
              height: 80,
              child: CustomNavBar(
                onPageChange: (int pageIndex) {
                  setState(() {
                    searchPage = false;
                    _currentlySelectedScreen = pageIndex;
                  });
                },
              )),
        ],
      ),
    );
  }
}
