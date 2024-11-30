import 'package:currensee_convertor_app/CurrencyConvertor.dart';
import 'package:currensee_convertor_app/appbar.dart';
import 'package:currensee_convertor_app/customdrawer.dart';
import 'package:flutter/material.dart';

class NavigationExample extends StatefulWidget {
  @override
  _NavigationExampleState createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width to decide between NavigationRail and BottomNavigationBar
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: "ss",
      ),
      body: Row(
        children: <Widget>[
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home_filled),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          if (isLargeScreen) VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: CurrencyConverter(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
