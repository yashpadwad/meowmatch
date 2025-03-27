import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart'; // ✅ Import GradientWrapper

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? ownerName, catName, catBreed, catAge, catGender, catHealth, catPersonality, catInterests;
  
  bool _isSaveButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Profile Setup", style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Owner Details
                Text("Owner Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                _buildTextField("Owner Name", (value) => ownerName = value),

                SizedBox(height: 20),

                // 📌 Cat Details
                Text("Cat Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                _buildTextField("Cat Name", (value) => catName = value),
                _buildTextField("Breed", (value) => catBreed = value),
                _buildTextField("Age", (value) => catAge = value),
                _buildTextField("Gender", (value) => catGender = value),
                _buildTextField("Health Status", (value) => catHealth = value),
                _buildTextField("Personality Traits", (value) => catPersonality = value),
                _buildTextField("Interests", (value) => catInterests),

                SizedBox(height: 30),

                // 📌 Save Profile Button
                _buildAnimatedButton(
                  text: "Save Profile",
                  color: Colors.pink,
                  icon: Icons.save,
                  isPressed: _isSaveButtonPressed,
                  onTap: () {
                    setState(() => _isSaveButtonPressed = false);
                    print("Profile Saved!");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Helper Function for Text Fields
  Widget _buildTextField(String label, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "Montserrat", color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  // ✅ Reusable Animated Button Function
  Widget _buildAnimatedButton({
    required String text,
    required Color color,
    required IconData icon,
    required bool isPressed,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: isPressed ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
