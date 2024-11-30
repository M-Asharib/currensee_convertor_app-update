import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true; // Track if the user is on the login or sign-up page
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticateUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final _auth = FirebaseAuth.instance;

    try {
      if (_isLogin) {
        // Log in user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        _showMessage('Logged in successfully');
      } else {
        // Sign up user
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        _showMessage('Account created successfully');
      }
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        // AppBar background color will use the theme's primary color
      ),
      // Background color will use the scaffold background color from the theme
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_emailController, 'Email', false),
            SizedBox(height: 20.0),
            _buildTextField(_passwordController, 'Password', true),
            SizedBox(height: 20.0),
            _buildSubmitButton(),
            SizedBox(height: 20.0),
            _buildSwitchAuthButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.grey[400], // Use theme or fallback color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _authenticateUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context)
              .primaryColor, // Use the primary color from the theme
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
    );
  }

  Widget _buildSwitchAuthButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(
          _isLogin
              ? 'Don\'t have an account? Sign Up'
              : 'Already have an account? Login',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
