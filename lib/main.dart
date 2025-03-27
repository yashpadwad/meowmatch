import 'package:flutter/material.dart';
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
        '/home': (context) => GradientWrapper(child: MainNavigation()), // ✅ New Main Navigation
        '/profile': (context) => GradientWrapper(child: ProfilePage()),
        '/matchmaking': (context) => GradientWrapper(child: MatchmakingPage()),
        '/payment': (context) => GradientWrapper(child: PaymentScreen()),
      },
    );
  }
}

// ✅ NEW BOTTOM NAVIGATION BAR SYSTEM
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MatchmakingPage(),  // 🔥 Home (Main Swiping)
    HomePage(),         // 🔍 Search
    MessagePage(catName: "Unknown Cat"), // ✅ FIXED: Provide a default cat name
    ProfilePage(),      // 👤 Profile
    PaymentScreen(),    // 💎 Premium
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientWrapper(child: _pages[_selectedIndex]), // ✅ Wrap with GradientWrapper
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






