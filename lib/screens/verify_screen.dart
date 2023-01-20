import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyScreen extends StatefulWidget {
  final String encodedData;
  const VerifyScreen({super.key, required this.encodedData});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isLoading = true;
  int statusCode = 0;
  String message = "";
  void verify() async {
    final Uri uri = Uri.parse(
        "https://easehack.azurewebsites.net/?encoded_data=${widget.encodedData}");
    var response = await http.post(uri);
    log("${response.statusCode}");
    setState(() {
      isLoading = false;
      statusCode = response.statusCode;
      message = response.body;
    });
  }

  @override
  void initState() {
    super.initState();
    verify();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : statusCode == 200
                ? message == "Forged!"
                    ? getVerification(false, message)
                    : getVerification(true, message)
                : getVerification(false, "Invalid QR Code"),
      ),
    ));
  }
}

Widget getVerification(bool isValid, String message) {
  message = message.replaceAll(RegExp(r'"'), '');
  // message = message.replaceFirst(RegExp(r'"'), '');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isValid ? Colors.greenAccent : Colors.redAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          isValid ? Icons.done : Icons.close,
          size: 80,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      Text(
        message,
        style: TextStyle(
          fontSize: 20,
        ),
      )
    ],
  );
}
