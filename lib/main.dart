import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:currensee_convertor_app/Auth.dart';
import 'package:currensee_convertor_app/CurrencyConvertor.dart';
import 'package:currensee_convertor_app/CurrencyData.dart';
import 'package:currensee_convertor_app/FAqs.dart';
import 'package:currensee_convertor_app/charts.dart';
import 'package:currensee_convertor_app/conversion_history_screen.dart';
import 'package:currensee_convertor_app/currencylist.dart';
import 'package:currensee_convertor_app/example.dart';
import 'package:currensee_convertor_app/examplenotification.dart';
import 'package:currensee_convertor_app/feedback.dart';
import 'package:currensee_convertor_app/home.dart';
import 'package:currensee_convertor_app/login.dart';
import 'package:currensee_convertor_app/navigationRail.dart';
import 'package:currensee_convertor_app/new_trend.dart';
import 'package:currensee_convertor_app/rateAlter.dart';
import 'package:currensee_convertor_app/theme.dart';
import 'package:currensee_convertor_app/webgoogleauth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null, // Use default icon
    [
      NotificationChannel(
        channelKey: 'basicchanel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notifications for general purposes',
        defaultColor: Colors.green,
        ledColor: Colors.white,
      )
    ],
    debug: true,
  );

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCYaHkCrgxkN6D6DvgoTBWmcZgmrHa596Y",
      authDomain: "ecommerceflutter-431f9.firebaseapp.com",
      projectId: "ecommerceflutter-431f9",
      storageBucket: "ecommerceflutter-431f9.appspot.com",
      messagingSenderId: "1048901164048",
      appId: "1:1048901164048:web:8b5259e09a66c5267d3e95",
      databaseURL: "https://ecommerceflutter-431f9-default-rtdb.firebaseio.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currensee Convertor App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Light Theme
      darkTheme: AppTheme.darkTheme, // Dark Theme
      themeMode: ThemeMode.system, // Follow System Theme
      routes: {
        '/': (csontext) => LoginScreen(), // Default Route (Login Screen)
        '/home': (context) => Home(), // Home Screen
        '/history': (context) =>
            ConversionHistoryScreen(), // Conversion History
        '/currency': (context) => SetCurrency(), // Currency Converter
        '/listofcountries': (context) => CurrencyList(), // List of Currencies
        '/news': (context) => NewsTrendsScreen(), // News and Trends
        '/noti': (context) => SetCurrency1(), // Notifications Management
        '/faq': (context) => HelpAndSupportPage(), // Notifications Management
      },
    );
  }
}
