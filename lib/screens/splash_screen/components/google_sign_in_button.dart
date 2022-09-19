import 'package:flutter/material.dart';
import 'package:mixyr/config/paths.dart';
import 'package:mixyr/config/response.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/screens/home/home_screen.dart';
import 'package:mixyr/state_handlers/firebase/firebase_handler.dart';
import 'package:mixyr/state_handlers/storage/storage_handler.dart';
import 'package:mixyr/widgets/buttons/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
            .singIn()
            .then((Map<Response, String> response) {
          if (response.keys.first == Response.success) {
            StorageHandler().isNewUser = false;
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
