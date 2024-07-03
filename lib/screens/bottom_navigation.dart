import 'package:flutter/material.dart';
import 'package:wni/screens/favorite_screen.dart';
import 'package:wni/screens/home_screen.dart';
import 'package:wni/screens/profile_screen.dart';
import 'package:wni/screens/search_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const TabBarView(
          children: [
            HomeScreen(),
            SearchScreen(),
            FavoriteScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 174, 144, 108),
          ),
          child: const TabBar(
              indicatorColor: Color.fromARGB(255, 113, 63, 53),
              labelColor: Color.fromARGB(255, 113, 63, 53),
              unselectedLabelColor: Color.fromARGB(255, 113, 63, 53),
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ]),
        ),
      ),
    );
  }
}
