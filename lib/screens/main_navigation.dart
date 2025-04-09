import 'package:flutter/material.dart';
import 'ExplorePage.dart';
import 'matchmaking_page.dart';
import 'profile_page.dart';
import 'chat_screen.dart'; // ✅ Updated chat screen
import 'payment_screen.dart';
import 'HealthPage.dart';
import 'package:meowmatch/widgets/gradient_wrapper.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MatchmakingPage(),  // 🔥 Matchmaking
    const ExplorePage(),      // 🔍 Explore
    const ChatScreen(),       // 💬 Chat List
    const ProfilePage(),      // 👤 Profile
    const PaymentScreen(),    // 💎 Premium
    const HealthPage(),       // 🩺 Health
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
        title: const Text("MeowMatch", style: TextStyle(fontFamily: "Poppins")),
        backgroundColor: Colors.pink,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Center(
                child: Text(
                  "MeowMatch Menu",
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text("Settings"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.black),
              title: const Text("Contact Support"),
              onTap: () => Navigator.pushNamed(context, '/contactSupport'),
            ),
          ],
        ),
      ),
      body: GradientWrapper(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
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
