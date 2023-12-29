import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/qr_scanner_screen/init_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheets/gsheets.dart';
import 'package:provider/provider.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = (await GoogleSignIn(
        scopes: ["https://www.googleapis.com/auth/spreadsheets"]).signIn());

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user!;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final authHeaders = await googleUser?.authHeaders;
    final authClient = GoogleAuthClient(authHeaders!);
    final User currentUser = FirebaseAuth.instance.currentUser!;
    assert(user.uid == currentUser.uid);
    final http.Client baseClient = http.Client();
    final AutoRefreshingAuthClient autoRefreshingClientMe =
        autoRefreshingClient(
      ClientId(
          "974613812048-3hp2554951o2gdr32ddfa4inrmcmj8et.apps.googleusercontent.com"),
      AccessCredentials(
        AccessToken("Bearer", (googleAuth?.accessToken)!,
            (await currentUser.getIdTokenResult()).expirationTime!.toUtc()),
        currentUser.refreshToken,
        ["https://www.googleapis.com/auth/spreadsheets"],
        idToken: await currentUser.getIdToken(),

        // refreshToken: googleAuth?,
      ),
      baseClient,
    );
    final gs = GSheets.withClient(autoRefreshingClientMe);
    print(gs);
    context.read<GoogleSheetsProvider>().initializeForWorksheet();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const InitQRScanner()));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: signInWithGoogle,
      child: const Text('Sign In with Google'),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = new http.Client();
  GoogleAuthClient(this._headers);
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _client.send(request..headers.addAll(_headers));
  }
}
