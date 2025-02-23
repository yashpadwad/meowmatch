import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/matchmaking_page.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/profile_page.dart';
import 'screens/payment_screen.dart'; // ✅ Import Payment Screen
import 'widgets/gradient_wrapper.dart';

void main() {
  runApp(const CatDatingApp());
}

class CatDatingApp extends StatelessWidget {
  const CatDatingApp({super.key});

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
        '/': (context) => GradientWrapper(child: HomePage()),
        '/signIn': (context) => GradientWrapper(child: SignInPage()),
        '/signUp': (context) => GradientWrapper(child: SignUpPage()),
        '/profile': (context) => GradientWrapper(child: ProfilePage()),
        '/matchmaking': (context) => GradientWrapper(child: MatchmakingPage()),
        '/payment': (context) => GradientWrapper(child: PaymentScreen()), // ✅ Added Payment Route
      },
    );
  }
}






