import 'package:flutter/material.dart';
import 'home_content.dart'; // Import HomeContent widget
import 'request_list_page.dart'; // Import RequestListPage widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Market Place'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Implement profile button onPressed action
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search button onPressed action
            },
          ),
        ],
      ),
      body: Center(
        child: _getSelectedPage(_currentIndex),
      ), // Use _getSelectedPage method to switch between pages
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outbox_rounded),
            label: 'Reuqest List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeContent(); // Show HomeContent for index 0 (Home)
      case 1:
        return RequestListPage(); // Show RequestListPage for index 1 (Notifications)
      case 2:
        return Container(); // Placeholder for Settings, add your settings page widget here
      default:
        return HomeContent(); // Default to HomeContent
    }
  }
}
