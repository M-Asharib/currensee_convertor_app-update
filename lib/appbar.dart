import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationIcon;
  final bool showMenuIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showNotificationIcon = true,
    this.showMenuIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Removes the back button
      backgroundColor: Color(0xFFFFFFFF), // AppBar background color
      elevation: 0, // Removes shadow
      title: Row(
        children: [
          Image.asset(
            'assets/logo_sm.png',
            width: 50, // Set width of the logo
            height: 50, // Set height of the logo
          ),
          SizedBox(width: 8), // Space between logo and title text
          Text(
            title,
            style: TextStyle(
              color: Colors.black, // Title text color
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        if (showNotificationIcon)
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notification button press
            },
          ),
        if (showMenuIcon)
          Builder(
            // Use Builder to provide a new context for Scaffold.of()
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  // Opens the drawer when menu icon is clicked
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
