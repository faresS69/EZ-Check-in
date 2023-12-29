import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/qr_scanner_screen/init_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) {
        return GoogleSheetsProvider("")..initializeForWorksheet();
      })
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => print(value));
    // FirebaseAuth auth = FirebaseAuth.instance;
    // auth
    //     .signInWithProvider(
    //       GoogleAuthProvider(),
    //     )
    //     .then((value) => print(value));
    context.read<GoogleSheetsProvider>();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitQRScanner(),
    );
  }
}
