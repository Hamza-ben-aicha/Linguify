import 'package:Linguify/Constants/Constants.dart';
import 'package:Linguify/screens/ChatPage.dart';
import 'package:Linguify/screens/ProfilePage.dart';
import 'package:Linguify/screens/SearchPage.dart';
import 'package:Linguify/screens/SettingsPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    ProfilePage(),
    ChatPage(),
    SearchPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent, // Set the background color to transparent
        child: ClipRRect(
          child: BottomNavigationBar(
            backgroundColor: THIRD_COLOR, // Light peach background color
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, color: PRIMARY_COLOR), // Dark color for unselected icons
                activeIcon: Icon(Icons.person, color: FIFTH_COLOR), // Orange color for selected icon
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, color: PRIMARY_COLOR), // Dark color for unselected icons
                activeIcon: Icon(Icons.chat_bubble, color: FIFTH_COLOR), // Orange color for selected icon
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined, color: PRIMARY_COLOR), // Dark color for unselected icons
                activeIcon: Icon(Icons.search, color: FIFTH_COLOR), // Orange color for selected icon
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, color: PRIMARY_COLOR), // Dark color for unselected icons
                activeIcon: Icon(Icons.settings, color: FIFTH_COLOR), // Orange color for selected icon
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: FIFTH_COLOR, // Orange color for selected icons
            unselectedItemColor: PRIMARY_COLOR, // Dark color for unselected icons
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed, // Ensures all items are displayed
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
