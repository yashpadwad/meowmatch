import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> likeUser(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _db
        .collection('users')
        .doc(currentUser.uid)
        .collection('likes')
        .doc(otherUserId)
        .set({'likedAt': FieldValue.serverTimestamp()});
  }

  static Future<bool> isMutualLike(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    final doc = await _db
        .collection('users')
        .doc(otherUserId)
        .collection('likes')
        .doc(currentUser.uid)
        .get();

    return doc.exists;
  }

  static Future<String> createOrGetChatId(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return '';

    final ids = [currentUser.uid, otherUserId]..sort();
    final chatId = ids.join("_");

    final chatRef = _db.collection('chats').doc(chatId);

    final exists = (await chatRef.get()).exists;
    if (!exists) {
      await chatRef.set({
        'participants': ids,
        'lastMessage': '',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  static Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  static Future<void> sendMessage(String chatId, String text) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final messageRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'text': text,
      'senderId': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }
}
