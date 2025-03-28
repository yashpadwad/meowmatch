import 'package:flutter/material.dart';
import 'screens/ExplorePage.dart';  // ✅ Correct Page Name
import 'screens/HealthPage.dart';  // ✅ New Health Page
import 'screens/home_page.dart';
import 'screens/matchmaking_page.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/profile_page.dart';
import 'screens/payment_screen.dart';
import 'screens/message_page.dart';
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
        '/': (context) => GradientWrapper(child: SignInPage()), // ✅ Start with Sign In
        '/signUp': (context) => GradientWrapper(child: SignUpPage()),
        '/home': (context) => GradientWrapper(child: MainNavigation()), // ✅ Main Navigation
        '/profile': (context) => GradientWrapper(child: ProfilePage()),
        '/matchmaking': (context) => GradientWrapper(child: MatchmakingPage()),
        '/payment': (context) => GradientWrapper(child: PaymentScreen()),
        '/health': (context) => GradientWrapper(child: HealthPage()), // ✅ New Health Page Route
      },
    );
  }
}

// ✅ UPDATED BOTTOM NAVIGATION BAR SYSTEM WITH "HEALTH"
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
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: "Health"), // ✅ New Health Tab
        ],
      ),
    );
  }
}


