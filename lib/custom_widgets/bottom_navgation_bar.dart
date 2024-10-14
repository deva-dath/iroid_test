import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      elevation: 5, // Adds elevation for shadow effect
      type: BottomNavigationBarType.fixed, // Ensures all labels are shown
      selectedItemColor: const Color.fromRGBO(
          93, 167, 163, 1), // Selected label and icon color
      unselectedItemColor: Colors.black, // Unselected label and icon color
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      items: const [
        BottomNavigationBarItem(
          icon:
              Icon(Icons.home), // Remove color here to allow auto color change
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons
              .fastfood), // Remove color here for selectedItemColor to apply
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Same for other icons
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}
