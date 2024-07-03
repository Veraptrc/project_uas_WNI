import 'package:cloud_firestore/cloud_firestore.dart';

class Wisata {
  String? id;
  final String nama;
  final String deskripsi;
  final String lokasi;
  final String latitude;
  final String longitude;
  String? imageUrl;
  Timestamp? timestamp;
  List<String>? likes;

  Wisata({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.timestamp,
    this.likes,
  });

  factory Wisata.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Wisata(
      id: doc.id,
      nama: data['nama'],
      deskripsi: data['deskripsi'],
      lokasi: data['lokasi'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      imageUrl: data['imageUrl'],
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  Wisata.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        nama = doc.data()!["nama"],
        deskripsi = doc.data()!["deskripsi"],
        lokasi = doc.data()!["lokasi"],
        latitude = doc.data()!["latitude"],
        longitude = doc.data()!["longitude"],
        imageUrl = doc.data()!["imageUrl"],
        timestamp = doc.data()!["timestamp"],
        likes = (doc.data()!["likes"] as List<dynamic>?)
            ?.map((like) => like.toString())
            .toList();
}
