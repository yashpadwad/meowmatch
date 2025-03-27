import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart';
import 'main_navigation.dart'; // ✅ Importing the bottom nav bar screen

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // ✅ Navigate to MainNavigation after sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid login credentials!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Sign In", style: TextStyle(fontFamily: "Poppins")),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontFamily: "Montserrat"),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontFamily: "Montserrat"),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Sign In",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 10),
                Text("Don't have an account?",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        color: Colors.white)),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    // ✅ Fixed navigation to SignUp page
                    Navigator.pushReplacementNamed(context, '/signUp');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink,
                    side: BorderSide(color: Colors.pink),
                  ),
                  child: Text("Sign Up",
                      style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
