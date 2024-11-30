import 'package:currensee_convertor_app/CurrencyData.dart';
import 'package:currensee_convertor_app/conversion_history_screen.dart';
import 'package:currensee_convertor_app/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  List<String> currencyList = [];
  double exchangeRate = 0.0;
  TextEditingController amountController = TextEditingController();
  double convertedAmount = 0.0;
  late User _user;
  String _userEmail = '';



  @override
  void initState() {
    super.initState();
    _getCurrencyData(fromCurrency);
    _getuser();
  }

  void _getuser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _userEmail = user.uid ?? '';
      });
    }
  }

  Future<void> _getCurrencyData(String baseCurrency) async {
    final response = await http.get(
      Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var rates = data['rates'];
      setState(() {
        currencyList = rates.keys.toList();
        exchangeRate = rates[toCurrency] ?? 0.0;
      });
    } else {
      throw Exception("Failed to load currency data");
    }
  }

  void _convertCurrency() {
    setState(() {
      double amount = double.parse(amountController.text);

      convertedAmount = amount * exchangeRate;
    });
  }

  void _convertCurrencybtn() {
    setState(() {
      double amount = double.parse(amountController.text);

      convertedAmount = amount * exchangeRate;

      firestore
          .collection('users')
          .doc(_userEmail)
          .collection('currencyhistory')
          .add({
        'from': fromCurrency,
        'toconvert': toCurrency,
        'amount': amount,
        'Convertedamount': convertedAmount,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Color(0xFFFFFFFF), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.black,
              onChanged: (value) {
                _convertCurrency();
              },
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Enter amount",
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200], // Match the color theme
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownSearch<String>(
              items: currencyList,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "From Currency",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[200], // Match the color theme
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              selectedItem: fromCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  fromCurrency = newValue!;
                  _getCurrencyData(fromCurrency);
                  _convertCurrency();
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
            ),
            SizedBox(height: 20),
            DropdownSearch<String>(
              items: currencyList,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "To Currency",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[200], // Match the color theme
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              selectedItem: toCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  toCurrency = newValue!;
                  _getCurrencyData(fromCurrency);
                  _convertCurrency();
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrencybtn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF36A03A), // Match the button color
              ),
              child: Text(
                "Convert",
                style: TextStyle(color: Colors.white),
                
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Converted Amount: $convertedAmount",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black, // Text color to match the theme
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Rate: $exchangeRate",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black, // Text color to match the theme
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SetCurrency()),
                );
              },
              child: Text(
                "Set Currency",
                style: TextStyle(
                  color: Colors.pinkAccent, // Match the accent color
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(  
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
              child: Text(
                "Convert History",
                style: TextStyle(
                  color: Colors.pinkAccent, // Match the accent color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
