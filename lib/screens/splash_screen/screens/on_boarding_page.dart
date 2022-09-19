import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixyr/config/palette.dart';
import 'package:mixyr/config/paths.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/config/utilities.dart';
import 'package:mixyr/screens/splash_screen/components/google_sign_in_button.dart';
import 'package:mixyr/widgets/background/gradient_background_overlay.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';
import 'package:mixyr/widgets/pages/page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  static const String id = "On Boarding Page";

  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late int _gradientBackgroundNumber = 0;
  static const double _backgroundHeight = 0.75;
  static const double _paddingBias =
      0.05; // Formula for top padding of content = 1 - _backgroundHeight - _contentTopPaddingBias

  final PageController _pageController = PageController();

  final Duration _pageTransitionDuration = const Duration(milliseconds: 700);
  final Curve _pageTransitionCurve = Curves.easeInOut;
  final List<String> _images = [
    paths[Paths.mixyrLogo]!,
    paths[Paths.warning]!,
    paths[Paths.user]!,
  ];
  final List<String> _titles = ['Mixyr', 'Warning', 'Sign in'];
  final List<List<TextSpan>> _content = const [
    [
      TextSpan(
          text: "Let the Music Speak!",
          style: TextStyle(fontWeight: FontWeight.w600))
    ],
    [
      TextSpan(text: "The app is "),
      TextSpan(
          text: "still in development ",
          style: TextStyle(fontWeight: FontWeight.w600)),
      TextSpan(
          text:
              "and I have not requested for verification. I will be doing in a few months. "),
      TextSpan(
          text:
              "Now while signing in you will presented to a screen asking if you trust me.For continuing with the app you have to accept it. ",
          style: TextStyle(fontWeight: FontWeight.w600, color: kWarn)),
      TextSpan(
          text:
              "This is a necessity since the app will collect data from your youtube account to provide a better experience."),
    ],
    [TextSpan(text: "")]
  ];

  @override
  void initState() {
    super.initState();
    _gradientBackgroundNumber = randomNumberGenerator();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      SizedBox(
        height: responsiveHeight(50, context),
      ),
      SizedBox(
        height: responsiveHeight(50, context),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: relativeHeight(0.3, context)),
        child: const GoogleSignInButton(),
      )
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
              height: relativeHeight(0.95, context),
              child: GradientBackgroundOverlay(
                backgroundNumber: _gradientBackgroundNumber,
                backgroundHeight: _backgroundHeight,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: relativeHeight(
                          1 - _backgroundHeight - _paddingBias, context)),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _titles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    index < _images.length
                                        ? SvgPicture.asset(_images[index],
                                            height:
                                                responsiveHeight(50, context),
                                            color: Theme.of(context).focusColor)
                                        : SizedBox(
                                            height:
                                                responsiveHeight(50, context),
                                            width: responsiveWidth(50, context),
                                          ),
                                    SizedBox(
                                        height: responsiveHeight(20, context)),
                                    Text(
                                      _titles[index],
                                      style: TextStyle(
                                          fontSize:
                                              responsiveWidth(30, context),
                                          letterSpacing: 7),
                                    ),
                                  ],
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize:
                                              responsiveWidth(15, context),
                                          fontWeight: FontWeight.w300,
                                          height: 1.2,
                                          letterSpacing: 1.2,
                                          color: Theme.of(context).focusColor),
                                      children: _content[index]),
                                ),
                                widgets[index]
                              ],
                            );
                          },
                        ),
                      ),
                      PageIndicator(
                        pageController: _pageController,
                        count: _titles.length,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ExpandedButton(
                              icon: Icons.chevron_left,
                              iconColor: Theme.of(context).focusColor,
                              onTap: () {
                                setState(() {
                                  _pageController.previousPage(
                                      duration: _pageTransitionDuration,
                                      curve: _pageTransitionCurve);
                                });
                              }),
                          ExpandedButton(
                            icon: Icons.chevron_right,
                            iconColor: Theme.of(context).focusColor,
                            onTap: () {
                              setState(() {
                                _pageController.nextPage(
                                    duration: _pageTransitionDuration,
                                    curve: _pageTransitionCurve);
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
