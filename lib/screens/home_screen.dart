import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:card_swiper/card_swiper.dart';

class HomeScreen extends StatelessWidget {
  final List<String> catImages = ['assets/cat1.jpg', 'assets/cat2.jpg', 'assets/cat3.jpg'];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cat Tinder 😻")),
      body: Center(
        child: Swiper(
          itemCount: catImages.length,
          itemBuilder: (context, index) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Image.asset(catImages[index]),
                SizedBox(height: 10),
                Text("Cute Cat ${index + 1}", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          loop: false,
          control: SwiperControl(),
          onIndexChanged: (index) {
            print("Swiped on Cat ${index + 1}");
          },
          onTap: (index) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
          },
        ),
      ),
    );
  }
}

