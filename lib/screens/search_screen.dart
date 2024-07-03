import 'package:flutter/material.dart';
import 'package:wni/components/dark_input_field.dart';
import 'package:wni/components/round_card.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/services/post_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Wisata> wisataList;
  List<Wisata> searchResult = [];

  void updateList(String text) {
    if (_searchController.text.isEmpty) {
      setState(() {
        searchResult.clear();
      });
    } else {
      setState(() {
        searchResult = wisataList
            .where((element) =>
                element.nama.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 245, 250, 225),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                DarkInputField(
                    controller: _searchController,
                    hintText: "Search..",
                    obscureText: false),
                Positioned(
                  right: 2.0,
                  top: 2.0,
                  child: IconButton(
                      iconSize: 28.0,
                      onPressed: () {
                        updateList(_searchController.text);
                      },
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Wisata>>(
              future: PostService.retrieveWisata(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Wisata found'));
                }
                wisataList = snapshot.data!;
                return ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    Wisata wisata = searchResult[index];
                    return RoundCard(
                      wisata: wisata,
                      withBottom: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
