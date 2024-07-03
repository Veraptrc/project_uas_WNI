import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:wni/components/input_field.dart';
import 'package:wni/screens/bottom_navigation.dart';
import 'package:wni/screens/home_screen.dart';
import 'package:wni/screens/signup_screen.dart';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
  clientId:
      '696455289874-cii8sc1t5lnlvgmr0s3q21fbshkd9bdp.apps.googleusercontent.com',
);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavigationScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> _signInWIthGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/logo_wni.png',
                height: 142,
              ),
              const Text(
                'LOGIN',
                style: TextStyle(
                  color: Color.fromARGB(255, 245, 250, 225),
                  fontSize: 54.0,
                ),
              ),
              //
              //
              const SizedBox(height: 16.0),
              //
              //
              InputField(
                controller: _emailController,
                labelText: 'Email',
                obscureText: false,
              ),
              InputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              //
              //
              const SizedBox(height: 38.0),
              //
              //
              ElevatedButton(
                onPressed: _signIn,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 245, 250, 225)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 100))),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 112.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 245, 250, 225),
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 245, 250, 225)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 245, 250, 225),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: _signInWIthGoogle,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 245, 250, 225)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 42))),
                icon: Image.asset(
                  'assets/gicon.png',
                  height: 18,
                ),
                label: const Text(
                  'Login with Google',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 48, 85, 77),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Color.fromARGB(255, 245, 250, 225),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
