import 'package:flutter/material.dart';

class RateAlertPage extends StatefulWidget {
  @override
  _RateAlertPageState createState() => _RateAlertPageState();
}

class _RateAlertPageState extends State<RateAlertPage> {
  String _selectedCurrencyPair = 'USD/EUR';
  final TextEditingController _rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Rate Alerts'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.deepPurple[700],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Choose Currency Pair', context),
              _buildCurrencyPairDropdown(),
              SizedBox(height: 20.0),
              _buildSectionTitle('Set Alert Threshold', context),
              _buildRateInput(),
              SizedBox(height: 20.0),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrencyPairDropdown() {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButton<String>(
          value: _selectedCurrencyPair,
          dropdownColor: Colors.deepPurple[500],
          isExpanded: true,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          items: <String>['USD/EUR', 'GBP/USD', 'AUD/JPY', 'EUR/JPY']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCurrencyPair = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRateInput() {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _rateController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter rate threshold (e.g., 1.2000)',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.deepPurple[400],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _setRateAlert(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text('Set Alert'),
      ),
    );
  }

  void _setRateAlert(BuildContext context) {
    final rate = _rateController.text;

    // Show a confirmation dialog for now
    // In a real application, you'd handle the logic for setting the alert
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Set!'),
          content: Text(
              'You will be notified when $_selectedCurrencyPair reaches $rate.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _rateController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
