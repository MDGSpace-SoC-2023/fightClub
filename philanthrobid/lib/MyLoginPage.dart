import 'package:flutter/material.dart';
import 'package:philanthrobid/signUpScreen.dart';
import 'package:philanthrobid/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});
  @override
  _MyLoginState createState() {
    return _MyLoginState();
  }
}

class _MyLoginState extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage = "";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            margin: const EdgeInsetsDirectional.only(bottom: 20),
            color: theme.canvasColor,
            child: const Text(
              "Welcome to Philanthrobid",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const Text("LOGIN",
              style: TextStyle(
                  fontSize: 20, decoration: TextDecoration.underline)),
          Container(
            margin:
                const EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "E-Mail ID",
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 246, 179, 202),
                    ),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(
                start: 20, end: 20, top: 10, bottom: 25),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                helperText: errorMessage,
                helperStyle: const TextStyle(
                  color: Colors.red,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 246, 179, 202),
                    ),
                    borderRadius: BorderRadius.circular(20)),
              ),
              obscureText: true,
            ),
          ),
          TextButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const homeScreen();
                      },
                    ),
                  );
                } catch (e) {
                  print("Wrong Credentials");
                  setState(() {
                    errorMessage = "Invalid Credentials";
                  });
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                theme.colorScheme.primary,
              )),
              child: const Text(
                "LOGIN",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const signUpScreen();
                    },
                  ),
                );
              },
              child: const Text("Don't have an account? Register"))
        ],
      ),
    ));
  }
}
