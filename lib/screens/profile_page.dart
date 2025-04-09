import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/gradient_wrapper.dart';
import 'sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? ownerName, catName, catBreed, catAge, catGender, catHealth, catPersonality, catInterests;
  String? profileImageUrl;
  final bool _isSaveButtonPressed = false;
  final bool _isLogoutButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data();
      setState(() {
        ownerName = data?['ownerName'];
        catName = data?['catName'];
        catBreed = data?['catBreed'];
        catAge = data?['catAge'];
        catGender = data?['catGender'];
        catHealth = data?['catHealth'];
        catPersonality = data?['catPersonality'];
        catInterests = data?['catInterests'];
        profileImageUrl = data?['profileImageUrl'];
      });
    }
  }

  void _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'ownerName': ownerName ?? '',
      'catName': catName ?? '',
      'catBreed': catBreed ?? '',
      'catAge': catAge ?? '',
      'catGender': catGender ?? '',
      'catHealth': catHealth ?? '',
      'catPersonality': catPersonality ?? '',
      'catInterests': catInterests ?? '',
      'profileImageUrl': profileImageUrl ?? '',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!"), backgroundColor: Colors.green),
    );
  }

  void _confirmLogout() async {
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully"), backgroundColor: Colors.green),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false,
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final ref = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();

      setState(() => profileImageUrl = url);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profileImageUrl': url,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile image updated!"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Profile Setup", style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Center(
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      child: profileImageUrl == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(child: Text("Tap to change photo", style: TextStyle(color: Colors.white70))),

                const SizedBox(height: 20),
                const Text("Owner Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                _buildTextField("Owner Name", (value) => ownerName = value, initialValue: ownerName),

                const SizedBox(height: 20),
                const Text("Cat Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                _buildTextField("Cat Name", (value) => catName = value, initialValue: catName),
                _buildTextField("Breed", (value) => catBreed = value, initialValue: catBreed),
                _buildTextField("Age", (value) => catAge = value, initialValue: catAge),
                _buildTextField("Gender", (value) => catGender = value, initialValue: catGender),
                _buildTextField("Health Status", (value) => catHealth = value, initialValue: catHealth),
                _buildTextField("Personality Traits", (value) => catPersonality = value, initialValue: catPersonality),
                _buildTextField("Interests", (value) => catInterests = value, initialValue: catInterests),

                const SizedBox(height: 30),
                _buildAnimatedButton("Save Profile", Colors.pink, Icons.save, _isSaveButtonPressed, _saveProfile),

                const SizedBox(height: 20),
                _buildAnimatedButton("Logout", Colors.redAccent, Icons.logout, _isLogoutButtonPressed, _confirmLogout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, ValueChanged<String> onChanged, {String? initialValue}) {
    final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: "Montserrat", color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAnimatedButton(
    String text,
    Color color,
    IconData icon,
    bool isPressed,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isPressed ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isPressed
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
