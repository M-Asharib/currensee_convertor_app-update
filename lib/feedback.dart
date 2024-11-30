import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final _feedbackController = TextEditingController();
  final _issueController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Colors.deepPurple[900],
      //   // backgroundColor: Color(0xFFF7E101),
      //   // backgroundColor: Color(0xFFA86EFB),
      //   backgroundColor: Colors.black,

      //   title: Text(
      //     'Feedback & Report Issues',
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      // ),

      backgroundColor: Color(0xFFF7F7F7),

      // backgroundColor: Colors.deepPurple[700],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildSectionTitle('We value your feedback', context),
              _buildFeedbackForm(),
              SizedBox(height: 20.0),
              // _buildSectionTitle('Report an Issue', context),
              _buildIssueForm(),
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
          color: Colors.black,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Card(
      color: Color(0xFFECEBE9),
      // color: Colors.deepPurple[300],
      // color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Feedback',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Let us know what you think...',
                hintStyle: TextStyle(color: Colors.black38),
                filled: true,
                // fillColor: Colors.deepPurple[400],
                fillColor: Colors.grey[100],

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueForm() {
    return Card(
      color: Color(0xFFECEBE9),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Describe the Issue',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _issueController,
              maxLines: 4,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Tell us what went wrong...',
                hintStyle: TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _submitFeedback(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF36A03A),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _submitFeedback(BuildContext context) async {
    final feedback = _feedbackController.text;
    final issue = _issueController.text;

    if (feedback.isNotEmpty || issue.isNotEmpty) {
      try {
        User? user = _auth.currentUser; // Get the current user
        String userEmail = user?.email ??
            'Anonymous'; // Default to 'Anonymous' if no user is signed in

        await _firestore.collection('feedback').add({
          'feedback': feedback,
          'issue': issue,
          'userEmail': userEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thank You!'),
              content: Text('Your feedback and issues have been submitted.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _feedbackController.clear();
                    _issueController.clear();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Handle errors here, such as showing an error message
        print('Error submitting feedback: $e');
      }
    } else {
      // Show an error message if no feedback or issue is provided
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please provide feedback or describe the issue.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
