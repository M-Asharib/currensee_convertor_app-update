import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex:
          selectedIndex, // Use the selectedIndex passed down from parent
      onTap: (index) {
        onItemTapped(index); // Update the selected index and navigate
      },
      backgroundColor: const Color(0xFFFFFFFF),
      selectedItemColor: Colors.black, // Set selected icon/text color to black
      unselectedItemColor: Colors.grey, // Set unselected icon/text color
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback),
          label: 'FeedBack',
        ),
      ],
    );
  }
}
