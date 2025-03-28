import 'package:flutter/material.dart';
import 'screens/ExplorePage.dart';
import 'screens/HealthPage.dart';
import 'screens/home_page.dart';
import 'screens/matchmaking_page.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/profile_page.dart';
import 'screens/payment_screen.dart';
import 'screens/message_page.dart';
import 'screens/SettingsPage.dart';  // ✅ Added Settings Page
import 'screens/ContactSupportPage.dart';  // ✅ Added Contact Support Page
import 'widgets/gradient_wrapper.dart';

void main() {
  runApp(const MeowMatchApp());
}

class MeowMatchApp extends StatelessWidget {
  const MeowMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeowMatch',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: "Montserrat",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GradientWrapper(child: SignInPage()), 
        '/signUp': (context) => GradientWrapper(child: SignUpPage()),
        '/home': (context) => GradientWrapper(child: MainNavigation()), 
        '/profile': (context) => GradientWrapper(child: ProfilePage()),
        '/matchmaking': (context) => GradientWrapper(child: MatchmakingPage()),
        '/payment': (context) => GradientWrapper(child: PaymentScreen()),
        '/health': (context) => GradientWrapper(child: HealthPage()),
        '/settings': (context) => GradientWrapper(child: SettingsPage()), // ✅ New Settings Route
        '/contactSupport': (context) => GradientWrapper(child: ContactSupportPage()), // ✅ New Contact Support Route
      },
    );
  }
}

// ✅ UPDATED NAVIGATION WITH DRAWER MENU
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MatchmakingPage(),  // 🔥 Home (Swiping)
    ExplorePage(),      // 🔍 Explore
    MessagePage(catName: "Unknown Cat"), // 💬 Chats
    ProfilePage(),      // 👤 Profile
    PaymentScreen(),    // 💎 Premium
    HealthPage(),       // 🏥 Health & Breed Info
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == 1 && index == 0) {
      return; // Prevents unwanted navigation back to home from explore
    }

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MeowMatch"),
        backgroundColor: Colors.pink,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white), 
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      // ✅ DRAWER MENU
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text(
                "MeowMatch Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // ✅ Navigate to Settings
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: Text("Contact Support"),
              onTap: () {
                Navigator.pushNamed(context, '/contactSupport'); // ✅ Navigate to Contact Support
              },
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


