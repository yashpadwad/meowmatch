import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/gradient_wrapper.dart'; 

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;

  Future<void> _makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10.00', 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'MeowMatch Premium',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Successful! 🎉")),
      );

      setState(() {
        paymentIntent = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: $e")),
      );
      print("Payment Error: $e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_YourSecretKeyHere', // ✅ Replace with your Stripe Secret Key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (double.parse(amount) * 100).toStringAsFixed(0), 
          'currency': currency,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print("Error Creating Payment Intent: $e");
      throw Exception("Failed to create payment intent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Upgrade to Premium", style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Unlock Premium Features! 🚀",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "• Unlimited Swipes\n• Video Calls & Messaging\n• Advanced Matchmaking\n• Verified Profiles & More!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontFamily: "Montserrat", color: Colors.white),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _makePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Upgrade for \$10", 
                  style: TextStyle(fontSize: 18, fontFamily: "Montserrat", fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
