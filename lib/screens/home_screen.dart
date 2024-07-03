import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wni/components/round_card.dart';
import 'package:wni/screens/notification_screen.dart';
import 'package:wni/screens/post_screen.dart';
import 'package:wni/screens/rencana_screen.dart';
import 'package:wni/services/post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      // backgroundColor: const Color.fromARGB(255, 245, 250, 225),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RencanaScreen()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.add),
                  Text("Rencanakan Wisatamu"),
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: PostService.getWisataList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: snapshot.data!.map((document) {
                        return RoundCard(
                          wisata: document,
                          withBottom: true,
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostScreen()),
          );
        },
        // backgroundColor: const Color.fromARGB(255, 48, 85, 77),
        child: const Icon(
          Icons.add,
          // color: Color.fromARGB(255, 245, 250, 225),
        ),
      ),
    );
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
