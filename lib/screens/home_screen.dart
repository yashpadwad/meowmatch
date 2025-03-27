import 'package:flutter/material.dart';
import 'message_page.dart'; // ✅ Import chat screen
import 'package:card_swiper/card_swiper.dart';

class HomeScreen extends StatelessWidget {
  final List<String> catImages = [
    'assets/cat1.jpg',
    'assets/cat2.jpg',
    'assets/cat3.jpg',
  ];

  final List<String> catNames = [
    "Whiskers",
    "Mittens",
    "Fluffy",
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MeowMatch 😻", style: TextStyle(fontFamily: "Poppins")),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Center(
        child: catImages.isNotEmpty
            ? Swiper(
                itemCount: catImages.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // ✅ Navigate to MessagePage when tapping the card
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessagePage(catName: catNames[index]),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.asset(
                              catImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/placeholder.jpg', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            catNames[index],
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
                                print("❌ Disliked ${catNames[index]}");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.green, size: 30),
                              onPressed: () {
                                print("❤️ Liked ${catNames[index]}");
                                // ✅ Open MessagePage when liked
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MessagePage(catName: catNames[index]),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                loop: false,
                control: const SwiperControl(),
                onIndexChanged: (index) {
                  print("🔄 Swiped on ${catNames[index]}");
                },
              )
            : const Center(
                child: Text(
                  "No more cats to match! 🐱",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}
