import 'package:ez_check_in/GsheetsURLDialog/gsheetsUrlDialog.dart';
import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/qr_scanner_screen/qr_scanner_screen.dart';
import 'package:ez_check_in/signInScreen/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';

// this will be the first widget of the app.
class InitQRScanner extends StatefulWidget {
  const InitQRScanner({Key? key}) : super(key: key);

  @override
  _InitQRScannerState createState() => _InitQRScannerState();
}

class _InitQRScannerState extends State<InitQRScanner> {
  final TextEditingController _textGsheetURLController =
      TextEditingController();
  late final TextEditingController _textSheetTitleController =
      TextEditingController(text: "Sheet1");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (mounted) {
      final url = await context.read<GoogleSheetsProvider>().getFormUrl();
      var fullurl = "https://docs.google.com/spreadsheets/d/";
      // _textGsheetURLController.text = url != null
      //     ? fullurl + url + "/"
      //     : fullurl + context.read<GoogleSheetsProvider>().spreadsheetID + "/";

      _textGsheetURLController.text =
          "$fullurl${context.read<GoogleSheetsProvider>().spreadsheetID}/";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textGsheetURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     if (mounted)
    //       _textGsheetURLController.text =
    //           "https://docs.google.com/spreadsheets/d/${context.read<GoogleSheetsProvider>().spreadsheetID}/";
    //   });
    // });
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // alignment: Alignment.center,
          children: [
            // Image.network(
            // 'https://res.cloudinary.com/startup-grind/image/upload/c_fill,w_500,h_500,g_center/c_fill,dpr_2.0,f_auto,g_center,q_auto:good/v1/gcs/platform-data-goog/events/DF23-Bevy-EventThumb-Blue%402x_ecdK6rb.png', // Replace with actual URL
            Image.asset(
              "assets/images/devfestIcon.webp",
              height: 200, // Adjust the size as needed
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
              },
              child: const Text('Scan QR Code'),
            ),
            ElevatedButton(
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return MyDialog(controller: _textGsheetURLController);
                    },
                  );
                });
              },
              child: const Text('Change Google Sheets URL'),
            ),
            Text(
                "Account credential :${context.watch<GoogleSheetsProvider>().randCred}"),
            DropdownButton(
              value: (context.read<GoogleSheetsProvider>().randCred),
              items: List.generate(19, (index) {
                return DropdownMenuItem(
                    child: Text("Account ${index + 1}"), value: index + 1);
              }),
              onChanged: (i) {
                print("this is from dropdown $i");
                context.read<GoogleSheetsProvider>().setRandCred(i!);
              },
            ),
            Padding(
                padding: EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    await context
                        .read<GoogleSheetsProvider>()
                        .initializeForWorksheet();
                  },
                  child: Icon(Icons.refresh),
                ))
          ],
        ),
      ),
      // )
    );
  }
}
