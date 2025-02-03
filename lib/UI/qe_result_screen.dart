import 'package:flutter/material.dart';

class QrResultScreen extends StatelessWidget {
  final String result;

  const QrResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanned Result")),
      body: Center(
        child: Container(
          height: 250,
          width: 300,
          child: Text(
            result,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}