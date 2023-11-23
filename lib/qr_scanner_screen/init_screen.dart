import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:ez_check_in/qr_scanner_screen/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';

class InitQRScanner extends StatelessWidget {
  const InitQRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
