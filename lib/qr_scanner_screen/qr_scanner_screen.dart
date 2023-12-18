import 'package:ez_check_in/providers/gsheets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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
            .checkInAttendee(value[1], "email")
            .then((checkedIn) async => {
                  if (mounted)
                    {
                      if (checkedIn)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              ' ${value[0]} has been checked .',
                              style: const TextStyle(color: Colors.black),
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
                                style: const TextStyle(color: Colors.black),
                              ),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red[300],
                            ),
                          )
                        }
                    }
                });
        // });
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
