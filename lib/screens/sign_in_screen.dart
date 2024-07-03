import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_uas_wni/screens/home_screen.dart';
import 'package:project_uas_wni/screens/sign_up_screen.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_uas_wni/screens/sign_up_screen.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  ValueNotifier userCredential = ValueNotifier('');

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
        ],
        clientId:
        //'37974253661-bf7jutp8u17m02uf1jbi9r6p5gfnfus8.apps.googleusercontent.com', //ANDROID CLIENT ID
        '356730112455-srouq4vg3bheutnpo0f5mme4j5fiefon.apps.googleusercontent.com', // WEB CLIENT ID
      ).signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 5),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  } catch (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                },
                child: const Text('Sign In'),
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
                child: const Text('Don\'t have an account? Sign up'),
              ),
              const SizedBox(height: 32.0),
              const Text(
                "--- Or Sign In With ---",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32.0),
              ValueListenableBuilder(
                valueListenable: userCredential,
                builder: (context, value, child) {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 5),
                      onPressed: () async {
                        userCredential.value = await signInWithGoogle();
                        if (userCredential.value != null)
                          print(userCredential.value.user!.email);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.png',
                          ),
                          Text('Sign in with Google')
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}