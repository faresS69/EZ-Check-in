import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/qr_scanner_screen/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendees_list/attendees_list.dart';
import 'attendees_list/attendees_list_from_json.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) => GoogleSheetsProvider("assets/credentials.json",
              "1lzZvXZ3-Sb2vDSLPZf9Rgo5bQtKCoTHu0EUwCdBNeQU", "Sheet1")
            ..initializeForWorksheet())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
