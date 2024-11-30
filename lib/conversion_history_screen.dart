import 'package:currensee_convertor_app/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversionHistoryScreen extends StatefulWidget {
  const ConversionHistoryScreen({super.key});

  @override
  State<ConversionHistoryScreen> createState() =>
      _ConversionHistoryScreenState();
}

class _ConversionHistoryScreenState extends State<ConversionHistoryScreen> {
  late User _user;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
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

  Future<void> _deleteAllRecords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userEmail)
          .collection('currencyhistory')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All records deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete records: $e')),
      );
    }
  }

  Future<void> _deleteSingleRecord(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userEmail)
          .collection('currencyhistory')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Set background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back icon
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        title: Text(
          'Conversion History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFFFFFFF), // Set AppBar color
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.black),
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete All Records'),
                  content: Text('Are you sure you want to delete all records?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirm) {
                await _deleteAllRecords();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_userEmail)
              .collection('currencyhistory')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black26, // Pink accent color for loader
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No data found',
                  style: TextStyle(
                    color: Colors.black, // Text color to match the theme
                    fontSize: 18.0,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var data = doc.data() as Map<String, dynamic>;

                return Card(
                  color: Color(0xFFFFFFFF), // Card color
                  child: ListTile(
                    title: Text(
                      '${data['from']} to ${data['toconvert']} - ${data['Convertedamount']}',
                      style: TextStyle(
                        color: Colors.black54, // White text color
                      ),
                    ),
                    subtitle: Text(
                      'Amount: ${data['amount']}',
                      style: TextStyle(
                        color: Colors.black54, // Slightly lighter for subtitle
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Date: ${(data['createdAt'] as Timestamp).toDate()}',
                          style: TextStyle(
                            color: Colors.black54, // Slightly lighter for date
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Record'),
                                content: Text(
                                    'Are you sure you want to delete this record?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm) {
                              await _deleteSingleRecord(doc.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
