import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/services/profile_service.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _wisataCollection =
      _database.collection('wisata');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = path.basename(file.path);
      Reference ref = _storage.ref().child('images').child('/$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(file.path));
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Stream<List<Wisata>> getWisataList() {
    return _wisataCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Wisata(
          id: doc.id,
          nama: data['nama'],
          deskripsi: data['deskripsi'],
          lokasi: data['lokasi'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          imageUrl: data['imageUrl'],
          timestamp: data['timestamp'],
          likes: List<String>.from(data['likes'] ?? []),
        );
      }).toList();
    });
  }

  static Stream<List<Wisata>> getFavoriteWisataList() {
    return _wisataCollection
        .where('likes', arrayContains: ProfileService.currentUser!.email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Wisata(
          id: doc.id,
          nama: data['nama'],
          deskripsi: data['deskripsi'],
          lokasi: data['lokasi'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          imageUrl: data['imageUrl'],
          timestamp: data['timestamp'],
          likes: List<String>.from(data['likes'] ?? []),
        );
      }).toList();
    });
  }

  static Future<List<Wisata>> retrieveWisata() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _wisataCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Wisata.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  // getter
  static CollectionReference get wisataCollection => _wisataCollection;
}
