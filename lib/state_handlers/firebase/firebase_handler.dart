import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mixyr/config/response.dart';

class FirebaseHandler extends ChangeNotifier {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  late FirebaseAuth _firebaseAuth;
  late YouTubeApi _youtubeApi;

  FirebaseHandler() {
    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/youtube.force-ssl']);
  }
  // -------------------------- Getter Methods --------------------------
  String? get getUserProfileLink => _user?.photoUrl;
  dynamic get getUserName => _user?.displayName;

  Future<Map<Response, String>> singIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return {Response.firebaseNoUser: ''};
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credentials);

      var httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient != null) {
        _youtubeApi = YouTubeApi(httpClient);
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
