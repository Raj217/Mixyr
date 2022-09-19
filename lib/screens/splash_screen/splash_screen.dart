import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/storage/storage_handler.dart';

import 'screens/loading_page.dart';
import 'screens/on_boarding_page.dart';

class SplashScreen extends StatelessWidget {
  static const String id = "Splash Screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StorageHandler().isNewUser
        ? const OnBoardingPage()
        : const LoadingPage();
  }
}
