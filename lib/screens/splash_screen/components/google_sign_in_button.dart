import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';
import 'package:mixyr/screens/home/home_screen.dart';
import 'package:mixyr/state_handlers/firebase/firebase_handler.dart';
import 'package:mixyr/utils/storage_handler.dart';
import 'package:mixyr/widgets/buttons/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:mixyr/utils/proxy_handler.dart';
import 'package:mixyr/packages/youtube_api/youtube_api.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: "Sign in with Google",
      backgroundColor: Theme.of(context).focusColor,
      leadingIcon: Image.asset(
        paths[Paths.google]!,
        height: responsiveWidth(30, context),
      ),
      onTap: () {
        Provider.of<FirebaseHandler>(context, listen: false)
            .signIn()
            .then((Map<Response, String> response) async {
          if (response.keys.first == Response.success) {
            Provider.of<YoutubeHandler>(context, listen: false).setYoutubeApi =
                YoutubeAPI(
                    youtubeApi:
                        Provider.of<FirebaseHandler>(context, listen: false)
                            .youtubeApi!);
            StorageHandler().isNewUser = false;
            if (await StorageHandler().getIsProxyEnabled()) {
              await ProxyHandler.setUpProxy(
                  host: '172.16.199.40', port: '8080');
            }
            Navigator.pushNamed(context, HomeScreen.id);
          } else if (response.keys.first == Response.firebasePlatformError) {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: response.values.first);
          }
        });
      },
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: responsiveWidth(15, context),
          fontWeight: FontWeight.w600),
    );
  }
}
