import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart'; // ✅ Import GradientWrapper

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "MeowMatch 😻",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: "Poppins", color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                "Find the purrfect match for your cat!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontFamily: "Montserrat", color: Colors.white),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text("Get Started", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


