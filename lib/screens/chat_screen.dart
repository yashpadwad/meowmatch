import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_page.dart';
import '../helpers/firestore_helper.dart'; // ✅ Your helper file

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> defaultCats = [
    {"name": "Whiskers", "image": "assets/cat1.jpg"},
    {"name": "Fluffy", "image": "assets/cat2.jpg"},
    {"name": "Mittens", "image": "assets/cat3.jpg"},
  ];

  List<Map<String, dynamic>> allChats = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestoreChats = await FirebaseFirestore.instance.collection('users').get();

    final realUsers = firestoreChats.docs
        .where((doc) => doc.id != user.uid)
        .map((doc) => {
              "name": doc['catName'] ?? "Unknown",
              "image": doc['profileImageUrl'] ?? '',
              "isDefault": false,
              "uid": doc.id,
            })
        .toList();

    setState(() {
      allChats = [
        ...realUsers,
        ...defaultCats.map((cat) => {
              "name": cat['name'],
              "image": cat['image'],
              "isDefault": true,
              "uid": '', // default cats don't have UID
            })
      ];
    });
  }

  void openChat(Map<String, dynamic> chat) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final isDefault = chat['isDefault'] == true;

    if (isDefault) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagePage(
            catName: chat['name'],
            chatId: "default_${chat['name']}",
            isDefault: true,
          ),
        ),
      );
    } else {
      final chatId = await FirestoreHelper.createOrGetChat(
        currentUser.uid,
        chat['uid'],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagePage(
            catName: chat['name'],
            chatId: chatId,
            isDefault: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.pink,
      ),
      body: allChats.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allChats.length,
              itemBuilder: (context, index) {
                final chat = allChats[index];
                final imageUrl = chat['image'];
                final isDefault = chat['isDefault'] == true;

                final ImageProvider imageProvider = imageUrl != null && imageUrl.isNotEmpty
                    ? (isDefault
                        ? AssetImage(imageUrl)
                        : NetworkImage(imageUrl)) as ImageProvider
                    : const AssetImage('assets/default_avatar.png');

                return ListTile(
                  leading: CircleAvatar(backgroundImage: imageProvider),
                  title: Text(chat['name'] ?? 'Unknown'),
                  subtitle: const Text("Tap to chat..."),
                  onTap: () => openChat(chat),
                );
              },
            ),
    );
  }
}
