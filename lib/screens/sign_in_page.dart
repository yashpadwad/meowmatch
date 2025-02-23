import 'package:flutter/material.dart';
import '../widgets/gradient_wrapper.dart'; 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        appBar: AppBar(title: Text("Sign In", style: TextStyle(fontFamily: "Poppins")), backgroundColor: Colors.pink),
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
                  validator: (value) => value!.isEmpty ? "Please enter your email" : null,
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
                  validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]), 
                SizedBox(height: 10),
                Text("Don't have an account?", style: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.white)),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink,
                    side: BorderSide(color: Colors.pink),
                  ),
                  child: Text("Sign Up", style: TextStyle(fontSize: 18, fontFamily: "Montserrat")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


