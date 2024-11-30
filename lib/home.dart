import 'package:currensee_convertor_app/CurrencyConvertor.dart';
import 'package:currensee_convertor_app/appbar.dart';
import 'package:currensee_convertor_app/custom_navigator_bar.dart';
import 'package:currensee_convertor_app/customdrawer.dart';
import 'package:currensee_convertor_app/feedback.dart';
import 'package:currensee_convertor_app/new_trend.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final bool showNotificationIcon;
  final bool showMenuIcon;

  // Constructor with default values
  const Home({
    super.key,
    this.showNotificationIcon = true, // Default value
    this.showMenuIcon = true, // Default value
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    CurrencyConverter(), // Page for Home
    NewsTrendsScreen(), // Page for News (Example, you can create this)
    FeedbackPage(), // Page for Notifications (Example, you can create this)
    FeedbackPage(), // Page for Profile (Example, you can create this)
  ];

  // This function is called when a BottomNavigationBar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showNotificationIcon: widget.showNotificationIcon,
        showMenuIcon: widget.showMenuIcon,
      ),
      drawer: CustomDrawer(),
      body: _pages[
          _selectedIndex], // Dynamically change body based on selected index
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
