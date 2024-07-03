import 'package:flutter/material.dart';
import 'package:wni/components/round_card.dart';
import 'package:wni/services/post_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: StreamBuilder(
        stream: PostService.getFavoriteWisataList(),
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
                    withBottom: false,
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
