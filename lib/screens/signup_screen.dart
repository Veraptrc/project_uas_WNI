import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wni/components/input_field.dart';
import 'package:wni/screens/bottom_navigation.dart';
import 'package:wni/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua input harus diisi')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Confirm password tidak sesuai dengan password')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        "profileUrl": "",
        "username": username,
        "alamat": "",
        "noTelp": "",
        "tanggalLahir": "",
        "jenisKelamin": ""
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavigationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password terlalu lemah')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Email sudah terpakai oleh pengguna lain')),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email yang dimasukkan tidak valid')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error terjadi: $e')),
      );
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
                height: 72,
              ),
              const Text(
                'REGISTER',
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
                controller: _usernameController,
                labelText: 'Username',
                obscureText: false,
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
              //
              //
              const SizedBox(height: 16.0),
              //
              //
              InputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              //
              //
              const SizedBox(height: 16.0),
              //
              //
              InputField(
                controller: _confirmController,
                labelText: 'Confirm Password',
                obscureText: true,
              ),
              //
              //
              const SizedBox(height: 54.0),
              ElevatedButton(
                onPressed: _register,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 245, 250, 225)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 100))),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
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
