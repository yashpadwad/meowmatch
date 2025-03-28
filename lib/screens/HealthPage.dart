import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Cat Health & Breed Info", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildHealthTile("Vaccinations 🏥", "Ensure your cat is up to date on essential vaccinations like rabies, feline distemper, and leukemia."),
            _buildHealthTile("Nutrition 🍲", "A balanced diet is crucial. Include high-protein foods and fresh water daily."),
            _buildHealthTile("Common Diseases ⚠️", "Be aware of conditions like feline diabetes, kidney disease, and obesity."),
            _buildHealthTile("Breed-Specific Health 🧬", "Different breeds have unique needs. Persian cats need daily grooming, while Siamese cats are prone to respiratory issues."),
            _buildHealthTile("Exercise & Mental Stimulation 🎾", "Regular playtime is essential for physical and mental well-being."),
            _buildHealthTile("Emergency Care 🚑", "Know the signs of distress: sudden vomiting, difficulty breathing, or lethargy."),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTile(String title, String description) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
            SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
