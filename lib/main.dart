import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'screens/ExplorePage.dart';
import 'screens/HealthPage.dart';
import 'screens/matchmaking_page.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/profile_page.dart';
import 'screens/payment_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/SettingsPage.dart';
import 'screens/ContactSupportPage.dart';

import 'widgets/gradient_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          ),
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/signUp': (context) => GradientWrapper(child: SignUpPage()),
        '/home': (context) => GradientWrapper(child: MainNavigation()),
        '/profile': (context) => GradientWrapper(child: ProfilePage()),
        '/matchmaking': (context) => GradientWrapper(child: MatchmakingPage()),
        '/payment': (context) => GradientWrapper(child: PaymentScreen()),
        '/health': (context) => GradientWrapper(child: HealthPage()),
        '/settings': (context) => GradientWrapper(child: SettingsPage()),
        '/contactSupport': (context) => GradientWrapper(child: ContactSupportPage()),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.pink)),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        }

        return const SignInPage();
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MatchmakingPage(),
    const ExplorePage(),
    const ChatScreen(),
    const ProfilePage(),
    const PaymentScreen(),
    const HealthPage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
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
                  style: TextStyle(color: Colors.amberAccent, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
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


