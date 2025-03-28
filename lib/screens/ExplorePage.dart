import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Explore", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent.withOpacity(0.9),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureTile(
                context,
                title: "🐾 Sitting",
                description: "Find trusted pet sitters near you!",
                color: Colors.blueAccent,
                icon: Icons.pets,
                onTap: () => _showFeatureMessage(context, "Sitting Feature Coming Soon!"),
              ),
              SizedBox(height: 16),
              _buildFeatureTile(
                context,
                title: "🩺 Vet Care",
                description: "Book vet appointments & telehealth services.",
                color: Colors.green,
                icon: Icons.local_hospital,
                onTap: () => _showFeatureMessage(context, "Vet Care Feature Coming Soon!"),
              ),
              SizedBox(height: 16),
              _buildFeatureTile(
                context,
                title: "☕ Cafe Date",
                description: "Plan pet-friendly cafe meetups!",
                color: Colors.orangeAccent,
                icon: Icons.coffee,
                onTap: () => _showFeatureMessage(context, "Cafe Date Feature Coming Soon!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showFeatureMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 16)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
