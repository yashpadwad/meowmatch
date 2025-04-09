import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_swiper/card_swiper.dart';

import 'message_page.dart';
import '../helpers/firestore_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    final fetchedProfiles = querySnapshot.docs
        .where((doc) => doc.id != user.uid)
        .map((doc) {
          final data = doc.data();
          return {
            'catName': data['catName'] ?? 'Unknown',
            'imageUrl': data['profileImageUrl'] ?? '',
            'uid': doc.id,
            'isDefault': false,
          };
        })
        .toList();

    final defaultProfiles = [
      {'catName': 'Whiskers', 'imageUrl': 'assets/cat1.jpg', 'isDefault': true},
      {'catName': 'Mittens', 'imageUrl': 'assets/cat2.jpg', 'isDefault': true},
      {'catName': 'Fluffy', 'imageUrl': 'assets/cat3.jpg', 'isDefault': true},
    ];

    setState(() {
      profiles = [...fetchedProfiles, ...defaultProfiles];
    });
  }

  Future<void> handleLike(Map<String, dynamic> profile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bool isDefault = profile['isDefault'] == true;

    if (isDefault) {
      final defaultChatId = "default_${profile['catName']}";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagePage(
            catName: profile['catName'],
            chatId: defaultChatId,
            isDefault: true,
          ),
        ),
      );
    } else {
      final otherUid = profile['uid'];

      await FirestoreHelper.likeUser(otherUid);
      final isMutual = await FirestoreHelper.isMutualLike(otherUid);

      if (isMutual) {
        final chatId = await FirestoreHelper.createOrGetChat(user.uid, otherUid);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagePage(
              catName: profile['catName'],
              chatId: chatId,
              isDefault: false,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❤️ Liked! Waiting for mutual match...")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MeowMatch 😻", style: TextStyle(fontFamily: "Poppins")),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Center(
        child: profiles.isEmpty
            ? const CircularProgressIndicator()
            : Swiper(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  final catName = profile['catName'];
                  final imageUrl = profile['imageUrl'];
                  final bool isDefault = profile['isDefault'] == true;

                  final ImageProvider imageProvider = imageUrl.toString().startsWith("http")
                      ? NetworkImage(imageUrl)
                      : (imageUrl.isNotEmpty
                          ? AssetImage(imageUrl)
                          : const AssetImage('assets/default_avatar.png')) as ImageProvider;

                  return GestureDetector(
                    onTap: () => handleLike(profile),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              catName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red, size: 30),
                                onPressed: () {
                                  print("❌ Disliked $catName");
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.green, size: 30),
                                onPressed: () => handleLike(profile),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loop: false,
                control: const SwiperControl(),
              ),
      ),
    );
  }
}


