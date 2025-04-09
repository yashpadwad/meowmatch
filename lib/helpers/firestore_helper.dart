import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Like a user
  static Future<void> likeUser(String otherEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _db
        .collection('users')
        .doc(currentUser.uid)
        .collection('likes')
        .doc(otherEmail)
        .set({'likedAt': Timestamp.now()});
  }

  // ✅ Check if mutual like exists
  static Future<bool> isMutualLike(String otherEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    final otherDoc = await _db
        .collection('users')
        .where('email', isEqualTo: otherEmail)
        .limit(1)
        .get();

    if (otherDoc.docs.isEmpty) return false;

    final otherId = otherDoc.docs.first.id;

    final likeBack = await _db
        .collection('users')
        .doc(otherId)
        .collection('likes')
        .doc(currentUser.email)
        .get();

    return likeBack.exists;
  }

  // ✅ Create or retrieve a chat
  static Future<String> createOrGetChat(String userId, String otherId) async {
    final chats = _db.collection('chats');
    final existing = await chats.where('participants', arrayContains: userId).get();

    for (var doc in existing.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherId)) return doc.id;
    }

    final newChat = await chats.add({
      'participants': [userId, otherId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  // ✅ Send message to a chat
  static Future<void> sendMessage(String chatId, String text) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _db.collection('chats').doc(chatId).collection('messages').add({
      'text': text,
      'senderId': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ✅ Get real-time messages stream
  static Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }
}
