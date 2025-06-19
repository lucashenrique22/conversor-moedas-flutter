import 'package:flutter/material.dart';
import 'currency_converter_home.dart';

void main() {
  runApp(CurrencyConverterApp());
}
class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      home: CurrencyConverterHome(),
    );
  }
}