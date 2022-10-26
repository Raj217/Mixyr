import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';
import 'package:mixyr/screens/splash_screen/components/google_sign_in_button.dart';
import 'package:mixyr/widgets/background/gradient_background_overlay.dart';
import 'package:mixyr/widgets/icons/mixyr_logo.dart';

class LoginPage extends StatefulWidget {
  static const String id = "Login Page";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late int _gradientBackgroundNumber = 0;
  final double _backgroundHeight = 0.75;

  @override
  void initState() {
    super.initState();
    _gradientBackgroundNumber = randomNumberGenerator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackgroundOverlay(
          backgroundHeight: _backgroundHeight,
          backgroundNumber: _gradientBackgroundNumber,
          child: Padding(
            padding: EdgeInsets.only(
                top: relativeHeight(1 - _backgroundHeight, context)),
            child: Column(
              children: [
                const MixyrLogo(
                  logoType: LogoType.vertical,
                  logoSize: 50,
                  fontSize: 30,
                ),
                SizedBox(
                  height: relativeHeight(0.1, context),
                ),
                const GoogleSignInButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
