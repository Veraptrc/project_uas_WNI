import 'package:flutter/material.dart';
import 'package:wni/components/detail_box.dart';
import 'package:wni/components/favorite_button.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/services/post_service.dart';
import 'package:wni/services/profile_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Wisata? wisata;
  const DetailScreen({super.key, required this.wisata});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLiked = false;

  // Jika user email dalam list likes car
  @override
  void initState() {
    super.initState();
    isLiked = widget.wisata!.likes!.contains(ProfileService.currentUser!.email);
  }

  void addOrRemoveLike() {
    setState(() {
      if (isLiked) {
        widget.wisata!.likes!.remove(ProfileService.currentUser!.email);
      } else {
        widget.wisata!.likes!.add(ProfileService.currentUser!.email.toString());
      }
      isLiked = !isLiked;
    });
  }

  void toggleLike() async {
    addOrRemoveLike();

    Map<String, dynamic> updatedLikes = {
      'likes': widget.wisata!.likes,
    };

    try {
      await PostService.wisataCollection
          .doc(widget.wisata!.id)
          .update(updatedLikes);
    } catch (e) {
      print('Error: $e');
      addOrRemoveLike();
    }
  }

  Future<void> openMap(String? lat, String? lng) async {
    Uri uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat, $lng");
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 250, 225),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                (widget.wisata?.imageUrl != null &&
                        Uri.parse(widget.wisata!.imageUrl!).isAbsolute
                    ? Image.network(
                        widget.wisata!.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container()),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.wisata!.nama,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      FavoriteButton(isLiked: isLiked, onTap: toggleLike),
                    ],
                  ),
                  //
                  const SizedBox(height: 2.0),
                  //
                  Text(
                    widget.wisata!.deskripsi,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  DetailBox(
                    section: "Lokasi",
                    text: widget.wisata!.lokasi,
                    icon: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      openMap(
                        widget.wisata!.latitude,
                        widget.wisata!.longitude,
                      );
                    },
                  ),
                  DetailBox(
                    section: "Latitude",
                    text: widget.wisata!.latitude,
                  ),
                  DetailBox(
                    section: "Longitude",
                    text: widget.wisata!.longitude,
                  ),
                  //
                  const SizedBox(height: 80)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
