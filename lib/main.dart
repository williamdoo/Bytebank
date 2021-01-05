import 'package:bytebank/screens/conta/lista.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.blueGrey[200],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey[200],
          textTheme: ButtonTextTheme.primary,
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          fillColor: Colors.blueGrey[200],
        ),
      ),
      home: ListaConta(),
    );
  }
}
