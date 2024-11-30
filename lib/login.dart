import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currensee_convertor_app/home.dart';
import 'package:currensee_convertor_app/webgoogleauth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true; // Track if user is on the login or sign-up page

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  // Gmail-specific validation
  bool _isGmail(String email) {
    final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return gmailRegex.hasMatch(email);
  }

  Future<void> _authenticateUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, return and show the error
      return;
    }

    try {
      if (_isLogin) {
        // Log in user
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        final DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        String role = userDoc['role'];

        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);

        // Navigate to appropriate screen based on role
        if (role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else if (role == 'user') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } else {
        // Sign up user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // Add role (e.g., 'user' by default) to Firestore for the newly created user
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'role': 'user', // Assign default role 'user'
          'createdAt': FieldValue
              .serverTimestamp(), // Optionally store account creation time
        });

        Fluttertoast.showToast(
            msg: "Account Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);

        // After signing up, navigate the user to the Home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      String errorMessage = 'An unknown error occurred';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'user-disabled':
            errorMessage = 'User account has been disabled.';
            break;
          default:
            errorMessage = e.message ?? 'An unknown error occurred.';
        }
      }
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      // appBar: AppBar(
      //   title: Text(_isLogin ? 'Login' : 'Sign Up'),
      //   backgroundColor: Colors.white, // Set AppBar color
      // ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Centralize content with padding for larger screens
          double containerWidth =
              constraints.maxWidth > 600 ? 600.0 : constraints.maxWidth;
          double horizontalPadding = constraints.maxWidth > 600 ? 100.0 : 16.0;

          return Padding(
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Container(
                color: Color(0xFFFFFFFF),
                width: containerWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // For smaller screens, show image above the form

                    Center(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(75.0), // Circular shape
                        child: Image.asset(
                          'assets/authimage.png', // Replace with your image path
                          height: 150.0,
                          // width: 250.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w900,
                        fontSize: 40.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildTextField(_emailController, 'Email', false),
                          SizedBox(height: 20.0),
                          _buildTextField(
                              _passwordController, 'Password', true),
                          SizedBox(height: 20.0),
                          _buildSubmitButton(),
                          SizedBox(height: 20.0),
                          _buildSwitchAuthButton(),
                          ElevatedButton(
                            onPressed: _signInWithGoogle,
                            child: Text('Sign in with Google'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      // Add Gmail validation for the email field
      validator: (value) {
        if (labelText == 'Email' && (value == null || value.isEmpty)) {
          return 'Please enter an email';
        } else if (labelText == 'Email' && !_isGmail(value!)) {
          return 'Please enter a valid Gmail address (example@gmail.com)';
        } else if (labelText == 'Password' &&
            (value == null || value.isEmpty)) {
          return 'Please enter a password';
        } else if (labelText == 'Password' && value!.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _authenticateUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
          textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        child: Text(
          _isLogin ? 'Login' : 'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSwitchAuthButton() {
    return Center(
      child: TextButton(
        onPressed: _toggleAuthMode,
        child: Text(
          _isLogin
              ? 'Don\'t have an account? Sign Up'
              : 'Already have an account? Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
