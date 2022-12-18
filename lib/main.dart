import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:mixyr/utils/storage_handler.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'state_handlers/audio/audio_player_handler.dart';
import 'state_handlers/firebase/firebase_handler.dart';
import 'state_handlers/theme/brightness/dark.dart';
import 'state_handlers/theme/brightness/light.dart';
import 'state_handlers/theme/theme_handler.dart';

ThemeHandler _themeHandler = ThemeHandler();
late AudioHandler _audioHandler;

void main() async {
  // ---------------------- initializing widget ----------------------
  WidgetsFlutterBinding.ensureInitialized();
  // ---------------------- initializing audio  ---------------------
  _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.raj.mixyr.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ));
  // ---------------------- initializing storage ---------------------
  StorageHandler();

  // ---------------------- initializing firebase ---------------------
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Paint.enableDithering = true;

  // debugRepaintRainbowEnabled = true;
  runApp(const Mixyr());
}

class Mixyr extends StatefulWidget {
  const Mixyr({Key? key}) : super(key: key);

  @override
  State<Mixyr> createState() => _MixyrState();
}

class _MixyrState extends State<Mixyr> {
  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _themeHandler.addListener(themeListener);
  }

  @override
  void dispose() {
    super.dispose();
    _themeHandler.removeListener(themeListener);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => FirebaseHandler()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                ThemeHandler(themeHandler: _themeHandler)),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                AudioHandlerAdmin(audioHandler: _audioHandler)),
        ChangeNotifierProvider(
            create: (BuildContext context) => YoutubeHandler()),
      ],
      child: MaterialApp(
        title: 'Mixyr',
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: _themeHandler.themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          HomeScreen.id: (BuildContext context) => const HomeScreen(),
          SplashScreen.id: (BuildContext context) => const SplashScreen(),
        },
      ),
    );
  }
}
