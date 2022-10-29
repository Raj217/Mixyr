import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mixyr/config/config.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class FirebaseHandler extends ChangeNotifier {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  late FirebaseAuth _firebaseAuth;
  String? currentVideoId;
  YouTubeApi? youtubeApi;

  FirebaseHandler() {
    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/youtube.force-ssl']);
  }
  Image? _userProfileImage;

  // -------------------------- Getter Methods --------------------------
  dynamic get getUserName => _user?.displayName;
  Image? get getUserProfileImage => _userProfileImage;
  YouTubeApi? get getYoutubeApi => youtubeApi;

  Future<Map<Response, String>> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return {Response.firebaseNoUser: ''};
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credentials);

      AuthClient? authClient = await _googleSignIn.authenticatedClient();
      if (authClient != null) {
        youtubeApi = YouTubeApi(authClient);
      }
      if (_user?.photoUrl != null) {
        _userProfileImage = Image.network(
          _user!.photoUrl!,
          fit: BoxFit.fill,
        );
      }
      return _user != null
          ? {Response.success: ''}
          : {Response.firebaseNoUser: ''};
    } on PlatformException catch (_) {
      return {
        Response.firebasePlatformError:
            'We encountered some error, please make sure you are not on an proxy network specially while authenticating with google. After this screen you may continue with your proxy network.'
      };
    } catch (e) {
      return {
        Response.unidentifiedError:
            'We encountered with some unknown error. Please restart the app.'
      };
    }
  }
}
