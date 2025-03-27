import 'package:flutter/material.dart';
import 'home_page.dart';
import 'matchmaking_page.dart';
import 'profile_page.dart';
import 'message_page.dart';
import 'payment_screen.dart';
import '../widgets/gradient_wrapper.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MatchmakingPage(), // 🔥 Home (Main Swiping)
    HomePage(), // 🔍 Search
    MessagePage(catName: "Chat"), // 💬 Matches & Chats (FIX: Added default catName)
    ProfilePage(), // 👤 Profile
    PaymentScreen(), // 💎 Premium
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientWrapper(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.diamond), label: "Premium"),
        ],
      ),
    );
  }
}

