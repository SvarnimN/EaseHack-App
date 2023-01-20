import 'dart:io';

import 'package:easehack/screens/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   //refresh the page here
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: buildQrView(context)),
    );
  }

  Widget buildQrView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        QRView(
          cameraFacing: CameraFacing.back,
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderWidth: 10,
            borderLength: 20,
            borderRadius: 10,
            borderColor: Colors.lightBlue,
            cutOutSize: MediaQuery.of(context).size.width * 0.8,
          ),
          onQRViewCreated: onQRViewCreated,
          onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
        ),
        Positioned(
          top: 100,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blueAccent,
            ),
            child: const Center(
              child: Text(
                "EaseHack",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      String result = scanData.code.toString();
      this.controller!.pauseCamera();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(
            encodedData: result,
          ),
        ),
      ).then((_) {
        this.controller!.resumeCamera();
      });
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
