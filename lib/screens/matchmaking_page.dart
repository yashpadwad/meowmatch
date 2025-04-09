import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_page.dart';
import '../widgets/gradient_wrapper.dart';
import '../helpers/firestore_helper.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  _MatchmakingPageState createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  List<Map<String, dynamic>> profiles = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> defaultProfiles = [
    {
      "image": "assets/cat1.jpg",
      "name": "Fluffy",
      "age": "2",
      "breed": "Persian",
      "isDefault": true,
    },
    {
      "image": "assets/cat2.jpg",
      "name": "Whiskers",
      "age": "3",
      "breed": "Siamese",
      "isDefault": true,
    },
    {
      "image": "assets/cat3.jpg",
      "name": "Mittens",
      "age": "1",
      "breed": "Maine Coon",
      "isDefault": true,
    },
    {
      "image": "assets/cat4.jpg",
      "name": "Shadow",
      "age": "4",
      "breed": "British Shorthair",
      "isDefault": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCatProfiles();
  }

  Future<void> fetchCatProfiles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final fetched = snapshot.docs
        .where((doc) => doc.id != user.uid)
        .map((doc) {
          final data = doc.data();
          return {
            "catName": data["catName"] ?? "Unknown",
            "catAge": data["catAge"] ?? "?",
            "catBreed": data["catBreed"] ?? "Unknown",
            "profileImageUrl": data["profileImageUrl"] ?? "",
            "email": data["email"] ?? "",
            "uid": doc.id,
            "isDefault": false,
          };
        }).toList();

    setState(() {
      profiles = [...fetched, ...defaultProfiles];
      isLoading = false;
    });
  }

  Future<void> swipeRight(Map<String, dynamic> profile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isDefault = profile['isDefault'] == true;

    if (isDefault) {
      final chatId = "default_${profile["name"]}";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagePage(
            chatId: chatId,
            catName: profile["name"] ?? "New Friend",
            isDefault: true,
          ),
        ),
      );
    } else {
      final otherEmail = profile['email'];
      final otherId = profile['uid'];

      await FirestoreHelper.likeUser(otherEmail);
      final isMutual = await FirestoreHelper.isMutualLike(otherEmail);

      if (isMutual) {
        final chatId = await FirestoreHelper.createOrGetChat(user.uid, otherId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagePage(
              chatId: chatId,
              catName: profile["catName"] ?? "New Friend",
              isDefault: false,
            ),
          ),
        );
      } else {
        showHeartExplosion(context);
      }
    }
  }

  void showHeartExplosion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: Icon(Icons.favorite, color: Colors.red, size: 100),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Find a Match! 😻",
              style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Swiper(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  final image = profile["profileImageUrl"] ??
                      profile["image"] ??
                      "assets/default_avatar.png";

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: image.toString().startsWith("http")
                              ? Image.network(image, fit: BoxFit.cover, width: double.infinity)
                              : Image.asset(image, fit: BoxFit.cover, width: double.infinity),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profile["catName"] ?? profile["name"]}, ${profile["catAge"] ?? profile["age"]} yrs",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile["catBreed"] ?? profile["breed"] ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 50,
                        right: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => print("❌ Disliked ${profile["catName"] ?? profile["name"]}"),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 30, color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => swipeRight(profile),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.favorite, size: 30, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loop: false,
                control: const SwiperControl(),
              ),
      ),
    );
  }
}

