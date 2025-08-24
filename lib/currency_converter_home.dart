import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CurrencyConverterHome extends StatefulWidget {
  const CurrencyConverterHome({super.key});

  @override
  State<CurrencyConverterHome> createState() => _CurrencyConverterHomeState();
}

class _CurrencyConverterHomeState extends State<CurrencyConverterHome> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double amount = 0.0;
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    _getCurrencies();
  }

  Future<void> _getCurrencies() async {
    
     var response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

     var data = json.decode(response.body);

    setState(() {
      currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
      rate = data['rates'][toCurrency] ?? 1.0;
    });
  }

  Future<void> _getRate() async {
    
     var response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'));

     var data = json.decode(response.body);

    setState(() {
      rate = data['rates'][toCurrency] ?? 1.0;
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 0.0;
                      total = amount * rate;
                    }); 
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String> (
                        value: fromCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF1d2630),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _swapCurrencies,
                      icon: Icon(
                        Icons.swap_horiz,
                        size: 40, 
                        color: Colors.white
                        ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String> (
                        value: toCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF1d2630),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            toCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('Rate: $rate', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                )
              ),
              SizedBox(height: 20),
              Text(total.toStringAsFixed(3),
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 30
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
