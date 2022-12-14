import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mixyr/config/config.dart';
import 'package:mixyr/screens/home/home_screen.dart';
import 'package:mixyr/state_handlers/firebase/firebase_handler.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:mixyr/widgets/icons/mixyr_logo.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:mixyr/utils/storage_handler.dart';
import 'package:mixyr/utils/proxy_handler.dart';
import 'package:mixyr/packages/youtube_api/youtube_api.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  static const String id = "Loading Page";

  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    Provider.of<FirebaseHandler>(context, listen: false)
        .signIn()
        .then((Map<Response, String> response) async {
      if (response.keys.first == Response.success) {
        Provider.of<YoutubeHandler>(context, listen: false).setYoutubeApi =
            YoutubeAPI(
          youtubeApi:
              Provider.of<FirebaseHandler>(context, listen: false).youtubeApi!,
        );
        if (await StorageHandler().getIsProxyEnabled()) {
          await ProxyHandler.setUpProxy(
              host: '172.16.199.40', port: '8080'); // TODO : make dynamic
        }
        Navigator.pushNamed(context, HomeScreen.id);
      } else if (response.keys.first == Response.firebaseNoUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: response.values.first,
        ).then(
          (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage()),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: relativeHeight(1, context),
          width: relativeWidth(1, context),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: relativeHeight(0.2, context),
              ),
              const MixyrLogo(
                logoType: LogoType.vertical,
                logoSize: 40,
                fontSize: 35,
              ),
              SizedBox(
                height: responsiveHeight(20, context),
              ),
              Lottie.asset(
                paths[Paths.lottieTree]!,
                controller: _lottieController,
                onLoaded: (controller) {
                  _lottieController.duration = controller.duration;
                  _lottieController.repeat();
                },
                height: responsiveHeight(180, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
