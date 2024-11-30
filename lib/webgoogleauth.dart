import 'package:currensee_convertor_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSignInWeb extends StatefulWidget {
  @override
  _GoogleSignInWebState createState() => _GoogleSignInWebState();
}

class _GoogleSignInWebState extends State<GoogleSignInWeb> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      // Create GoogleAuthProvider instance
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Sign in using popup (shows browser accounts)
      final UserCredential userCredential =
          await _auth.signInWithPopup(googleProvider);

      // Access user details
      final User? user = userCredential.user;
      if (user != null) {
        print('Signed in as: ${user.displayName}');
        print('Email: ${user.email}');
        print('Photo URL: ${user.photoURL}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${user.displayName}!')),
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to sign in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In Web')),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGoogle,
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
