import 'package:flutter/material.dart';

class GradientWrapper extends StatelessWidget {
  final Widget child;

  const GradientWrapper({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 249, 167, 246), // Light pink
            Color.fromARGB(255, 0, 255, 255),  // Cyan blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ Transparent background
        body: child,
      ),
    );
  }
}

