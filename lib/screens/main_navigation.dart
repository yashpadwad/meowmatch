import 'package:flutter/material.dart';
import 'ExplorePage.dart'; 
import 'matchmaking_page.dart';
import 'profile_page.dart';
import 'message_page.dart';
import 'payment_screen.dart';
import 'HealthPage.dart'; // ✅ Health Page
import 'SettingsPage.dart'; // ✅ Settings Page
import 'ContactSupportPage.dart'; // ✅ Contact Support Page
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
    HealthPage(),       // 🏥 Health
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MeowMatch"),
        backgroundColor: Colors.pink,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white), // ☰ Drawer Menu Icon
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      // ✅ DRAWER MENU (Safe & Styled)
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.pink),
                child: Center(
                  child: Text(
                    "MeowMatch Menu",
                    style: TextStyle(
                      color: Colors.amberAccent, // 🌟 Golden Header
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pushNamed(context, '/settings'); // ✅ Named Route
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support, color: Colors.black),
                title: Text("Contact Support"),
                onTap: () {
                  Navigator.pushNamed(context, '/contactSupport'); // ✅ Named Route
                },
              ),
            ],
          ),
        ),
      ),

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
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: "Health"),
        ],
      ),
    );
  }
}


