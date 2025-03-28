import 'package:flutter/material.dart';
import 'ExplorePage.dart'; 
import 'matchmaking_page.dart';
import 'profile_page.dart';
import 'message_page.dart';
import 'payment_screen.dart';
import 'HealthPage.dart'; // ✅ Added Health Page
import 'package:meowmatch/widgets/gradient_wrapper.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Default: Home page

  final List<Widget> _pages = [
    MatchmakingPage(),  // 🔥 Home
    ExplorePage(),      // 🔍 Explore
    MessagePage(catName: "Unknown Cat"), // 💬 Chats
    ProfilePage(),      // 👤 Profile
    PaymentScreen(),    // 💎 Premium
    HealthPage(),       // 🏥 Health (NEW)
  ];

  void _onItemTapped(int index) {
    // Prevent navigation from "Explore" (index 1) back to "Home" (index 0)
    if (_selectedIndex == 1 && index == 0) {
      return;
    }

    // Update only if a new page is selected
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
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
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"), 
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.diamond), label: "Premium"),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: "Health"), // ✅ Added Health Button
        ],
      ),
    );
  }
}


