import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? _activeItemIndex;
  int? _hoveredItemIndex;

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Theme's primary color
    final backgroundColor = theme.scaffoldBackgroundColor; // Background color
    final textColor = theme.textTheme.bodyLarge!.color!; // Text color
    final dividerColor = theme.dividerColor; // Divider color

    return Drawer(
      elevation: 0,
      child: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo and header section
              CustomDrawerHeader(
                  primaryColor: primaryColor, dividerColor: dividerColor),
              // Menu items
              // _buildDrawerItem(0, 'HOME', Icons.home, () {
              //   Navigator.pushNamed(context, '/home');
              // }),
              // _buildDrawerItem(1, 'CURRENCY CONVERTER', Icons.attach_money, () {
              //   Navigator.pushNamed(context, '/convertor');
              // }),
              // _buildDrawerItem(2, 'NEWS', Icons.newspaper, () {
              //   Navigator.pushNamed(context, '/news');
              // }),
              _buildDrawerItem(3, 'SUPPORT & HELP CENTER', Icons.help_outline,
                  () {
                Navigator.pushNamed(context, '/support');
              }),
              _buildDrawerItem(4, 'LIST OF CURRENCIES', Icons.list, () {
                Navigator.pushNamed(context, '/listofcountries');
              }),
              _buildDrawerItem(5, 'FEEDBACK', Icons.feedback, () {
                Navigator.pushNamed(context, '/feedback');
              }),
              _buildDrawerItem(6, 'SET RATE ALERT', Icons.notifications, () {
                Navigator.pushNamed(context, '/currency');
              }),
              _buildDrawerItem(7, 'HISTORY', Icons.history, () {
                Navigator.pushNamed(context, '/history');
              }),
              _buildDrawerItem(8, 'SETTINGS', Icons.settings, () {
                Navigator.pushNamed(context, '/settings');
              }),
              // Divider(color: dividerColor), // Divider line with theme color
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'DESIGN & DEVELOP BY',
                  style: TextStyle(
                      color: textColor.withOpacity(0.7), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  'WEB berners',
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for building drawer items
  Widget _buildDrawerItem(
      int index, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge!.color!; // Use theme text color
    final iconColor =
        theme.iconTheme.color ?? Colors.amber; // Use theme icon color

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredItemIndex = index;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredItemIndex = null;
              });
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                ),
              ),
              tileColor: _getTileColor(index),
              onTap: () {
                setState(() {
                  _activeItemIndex = index;
                });
                onTap();
              },
            ),
          ),
          Divider(color: theme.dividerColor, height: 1, thickness: 1),
        ],
      ),
    );
  }

  // Helper function to determine the color of the tile
  Color _getTileColor(int index) {
    if (_activeItemIndex == index) {
      return Colors.grey.shade800;
    }
    if (_hoveredItemIndex == index) {
      return Colors.grey.shade700;
    }
    return Colors.transparent;
  }
}

// Custom Drawer Header with theme support
class CustomDrawerHeader extends StatelessWidget {
  final Color primaryColor;
  final Color dividerColor;

  const CustomDrawerHeader({
    super.key,
    required this.primaryColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Icon(
                  Icons.currency_exchange,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'currency\nconvertor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 1,
            color: dividerColor,
          ),
        ],
      ),
    );
  }
}
