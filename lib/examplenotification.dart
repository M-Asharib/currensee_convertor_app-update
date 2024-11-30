import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetCurrency1 extends StatefulWidget {
  @override
  _SetCurrency1State createState() => _SetCurrency1State();
}

class _SetCurrency1State extends State<SetCurrency1> {
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
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    _getCurrencyData(fromCurrency);
    _getuser();
  }

  void triggerNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }

  void _getuser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _userEmail = user.uid;
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

  void _convertCurrencybtn() async {
    double amount = double.parse(amountController.text);
    double convertedAmount = amount * exchangeRate;

    final userDocRef =
        firestore.collection('users').doc(_userEmail).collection('Setcurrency');

    final querySnapshot =
        await userDocRef.where('amount', isEqualTo: amount).get();

    if (querySnapshot.docs.isEmpty) {
      await userDocRef.add({
        'from': fromCurrency,
        'toconvert': toCurrency,
        'amount': amount,
        'Convertedamount': convertedAmount,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(
        msg: "Currency conversion added.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "This conversion amount already exists.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Function to set a rate alert
  void _setRateAlert() {
    TextEditingController rateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Rate Alert"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown(currencyList, "From Currency", fromCurrency,
                  (String? newValue) {
                setState(() {
                  fromCurrency = newValue!;
                });
              }),
              SizedBox(height: 10),
              _buildDropdown(currencyList, "To Currency", toCurrency,
                  (String? newValue) {
                setState(() {
                  toCurrency = newValue!;
                });
              }),
              SizedBox(height: 10),
              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Target Rate",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                double targetRate = double.parse(rateController.text);

                await firestore
                    .collection('users')
                    .doc(_userEmail)
                    .collection('RateAlerts')
                    .add({
                  'from': fromCurrency,
                  'to': toCurrency,
                  'targetRate': targetRate,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Fluttertoast.showToast(
                  msg: "Rate alert set successfully.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                Navigator.of(context).pop();
              },
              child: Text("Set Alert"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Set Rate',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: _setRateAlert,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
                amountController, "Enter Amount", TextInputType.number),
            SizedBox(height: 20),
            _buildDropdown(currencyList, "From Currency", fromCurrency,
                (String? newValue) {
              setState(() {
                fromCurrency = newValue!;
                _getCurrencyData(fromCurrency);
              });
            }),
            SizedBox(height: 20),
            _buildDropdown(currencyList, "To Currency", toCurrency,
                (String? newValue) {
              setState(() {
                toCurrency = newValue!;
                _getCurrencyData(fromCurrency);
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrencybtn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF36A03A),
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              ),
              child: Text("Convert", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(_userEmail)
                    .collection('Setcurrency')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Data Available'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data =
                          doc.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(
                            '${data['from']} to ${data['toconvert']} - ${data['Convertedamount']}'),
                        subtitle: Text('Amount: ${data['amount']}'),
                        trailing: Text(
                            'Created At: ${data['createdAt']?.toDate()?.toString()}'),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String labelText,
      String selectedItem, ValueChanged<String?> onChanged) {
    return DropdownSearch<String>(
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      selectedItem: selectedItem,
      onChanged: onChanged,
      popupProps: PopupProps.menu(
        showSearchBox: true,
      ),
    );
  }
}
