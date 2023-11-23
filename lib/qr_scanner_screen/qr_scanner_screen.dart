import 'dart:convert';

import 'package:ez_check_in/classes/attendee.dart';
import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:gsheets/gsheets.dart';
import '../widgets/custom_drawer.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  final String? qrDataCode = null;
  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  Barcode? result;
  bool isCameraPaused = false;
  bool isFlashOn = false;
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      (isCameraPaused)
                          ? {
                              setState(() {
                                isCameraPaused = false;
                              }),
                              controller.resumeCamera()
                            }
                          : true;
                    },
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.green,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300,
                      ),
                    )),
                (isCameraPaused || isProcessing)
                    ?
                    // ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         padding: EdgeInsets.all(20),
                    //         backgroundColor: Colors.transparent),
                    //     // shape: RoundedRectangleBorder(
                    //     //     borderRadius: BorderRadius.all(Radius.circular(16))),
                    //     onPressed: () {
                    //       controller.resumeCamera();
                    //       setState(() {
                    //         isCameraPaused = false;
                    //       });
                    //     },
                    // child:
                    (!isProcessing && isCameraPaused)
                        ? GestureDetector(
                            onTap: () {
                              (isCameraPaused)
                                  ? {
                                      setState(() {
                                        isCameraPaused = false;
                                      }),
                                      controller.resumeCamera()
                                    }
                                  : true;
                            },
                            child: const Text(
                              "Tap to Resume",
                              style: TextStyle(color: Colors.white),
                            ))
                        : const CircularProgressIndicator()
                    // )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
      controller.toggleFlash();
    });
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) async {
        print(await controller.getCameraInfo());
        if (scanData.code == null) return;
        controller.pauseCamera();
        setState(() {
          isCameraPaused = true;
        });
        print(scanData.code?.split("/"));
        List<String> value = scanData.code?.split("/") as List<String>;
        isProcessing = true;
        context
            .read<GoogleSheetsProvider>()
            .checkInAttendee(value[0])
            .then((checkedIn) async => {
                  if (mounted)
                    {
                      if (checkedIn)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              ' ${value[0]} has been checked in.',
                              style: TextStyle(color: Colors.black),
                            ),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.green[300],
                          )),
                        }
                      else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Some error happened while check-in of ${value[0]}.',
                                style: TextStyle(color: Colors.black),
                              ),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red[300],
                            ),
                          )
                        }
                    }
                });
        // String credentialsJson =
        //     await rootBundle.loadString('assets/credentials.json');
        // var gsheets = GSheets(jsonDecode(credentialsJson));
        // final ss = await gsheets
        //     .spreadsheet("1lzZvXZ3-Sb2vDSLPZf9Rgo5bQtKCoTHu0EUwCdBNeQU");
        // final ws = ss.worksheetByTitle("Sheet1");
        // if (ws == null) return;
        // // Handle the scanned QR code data here
        // // You can use scanData.code to get the content of the QR code

        // var rowIndex = await ws.values.rowIndexOf(value[0], inColumn: 1);
        // if (rowIndex == -1) {
        //   return;
        // }
        // if ((await ws.values.row(rowIndex))[4] == "TRUE") return;
        // ws.values
        //     .insertColumn(5, ["TRUE"], fromRow: rowIndex)
        //     .then((checkedIn) {
        //   if (checkedIn) {
        //     if (mounted) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(
        //             ' ${value[0]} have  been checked in.',
        //             style: TextStyle(color: Colors.black),
        //           ),
        //           duration: const Duration(seconds: 3),
        //           backgroundColor: Colors.green[400],
        //         ),
        //       );
        //       // Navigator.pop(context);
        //     }
        //   }
        // });
        // if (checkin_success) {
        //   controller.pauseCamera();
        // }

        // For example, you can use it to mark the attendee as present
        // You can also navigate to another screen or perform any other action based on the scanned data
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          isProcessing = false;
        });
      }, onDone: () async {
        // await Future.delayed(Duration(seconds: 3));
        print("done scanning");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
