import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _controller = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _exchangeRate = 0.88; // Placeholder rate, replace with API data
  List<String> _conversionHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[700],
      appBar: AppBar(
        title: Text('Currency Converter'),
        backgroundColor: Colors.deepPurple[900],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[900],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Convert'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Conversion History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversionHistoryPage(
                      conversionHistory: _conversionHistory,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
   
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: 'Enter amount in $_fromCurrency',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.deepPurple[500],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _fromCurrency,
                  dropdownColor: Colors.deepPurple[500],
                  items: ['USD', 'EUR', 'GBP'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _fromCurrency = newValue!;
                    });
                  },
                ),
                SizedBox(width: 20.0),
                Icon(Icons.swap_horiz, color: Colors.white),
                SizedBox(width: 20.0),
                DropdownButton<String>(
                  value: _toCurrency,
                  dropdownColor: Colors.deepPurple[500],
                  items: ['USD', 'EUR', 'GBP'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _toCurrency = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              onPressed: _convertCurrency,
              child: Text('Convert'),
            ),
            SizedBox(height: 20.0),
            Text(
              _controller.text.isEmpty
                  ? 'Converted Amount:'
                  : 'Converted Amount: ${(double.tryParse(_controller.text) ?? 0) * _exchangeRate} $_toCurrency',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _convertCurrency() {
    setState(() {
      // Save the conversion to the history
      String conversion = '${_controller.text} $_fromCurrency = '
          '${(double.tryParse(_controller.text) ?? 0) * _exchangeRate} $_toCurrency';
      _conversionHistory.add(conversion);

      // Clear the input after conversion
      _controller.clear();
    });
  }
}

class ConversionHistoryPage extends StatelessWidget {
  final List<String> conversionHistory;

  ConversionHistoryPage({required this.conversionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion History'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.deepPurple[700],
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: conversionHistory.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.deepPurple[500],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                conversionHistory[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
