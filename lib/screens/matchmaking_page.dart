import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'message_page.dart';
import '../widgets/gradient_wrapper.dart'; // ✅ Import GradientWrapper

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  _MatchmakingPageState createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  final List<Map<String, String>> catProfiles = [
    {"image": "assets/cat1.jpg", "name": "Fluffy", "age": "2", "breed": "Persian"},
    {"image": "assets/cat2.jpg", "name": "Whiskers", "age": "3", "breed": "Siamese"},
    {"image": "assets/cat3.jpg", "name": "Mittens", "age": "1", "breed": "Maine Coon"},
    {"image": "assets/cat4.jpg", "name": "Shadow", "age": "4", "breed": "British Shorthair"},
  ];

  void swipeRight(BuildContext context, int index) {
    showHeartExplosion(context, index);
  }

  void showHeartExplosion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child: Icon(Icons.favorite, color: Colors.red, size: 100),
            ),
          ],
        );
      },
    );

    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MessagePage(catName: catProfiles[index]["name"]!)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Find a Match! 😻", style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Swiper(
            itemCount: catProfiles.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        catProfiles[index]["image"]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  // ✅ Profile Details Overlay
                  Positioned(
                    bottom: 100,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${catProfiles[index]["name"]}, ${catProfiles[index]["age"]} years old",
                            style: TextStyle(fontSize: 22, fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "${catProfiles[index]["breed"]}",
                            style: TextStyle(fontSize: 18, fontFamily: "Montserrat", color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ Cross & Heart Buttons
                  Positioned(
                    bottom: 20,
                    left: 50,
                    right: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ❌ Cross (Dislike) Button
                        GestureDetector(
                          onTap: () => print("Disliked ${catProfiles[index]["name"]}"),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                            ),
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.close, size: 40, color: Colors.white),
                          ),
                        ),

                        // ❤️ Heart (Like) Button
                        GestureDetector(
                          onTap: () => swipeRight(context, index),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                            ),
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.favorite, size: 40, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loop: false,
            control: SwiperControl(),
            onIndexChanged: (index) => print("Swiped ${catProfiles[index]['name']}"),
          ),
        ),
      ),
    );
  }
}

