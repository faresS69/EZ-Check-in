import 'package:ez_check_in/qr_scanner_screen/init_screen.dart';
import 'package:flutter/material.dart';
import 'attendees_list/attendees_list.dart';
import 'attendees_list/attendees_list_from_json.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
