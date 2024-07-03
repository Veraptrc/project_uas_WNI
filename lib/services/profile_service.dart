import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wni/models/profile.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

class ProfileService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _database.collection('users');
  static final User? _currentUser = FirebaseAuth.instance.currentUser;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Stream<Profile> getUserProfile() {
    return _usersCollection.doc(currentUser!.uid).snapshots().map((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Profile(
        id: snapshot.id,
        profileUrl: data['profileUrl'],
        username: data['username'],
        alamat: data['alamat'],
        email: currentUser!.email,
        noTelp: data['noTelp'],
        tanggalLahir: data['tanggalLahir'],
        jenisKelamin: data['jenisKelamin'],
      );
    });
  }

  static Future<String?> uploadImage(XFile file) async {
    try {
      String fileName = path.basename(file.path);
      Reference ref = _storage.ref().child('images').child('profile/$fileName');
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

  static Future<void> updateProfilePicture(
      Profile profile, String? profileUrl) async {
    Map<String, dynamic> updatedProfilePic = {
      'profileUrl': profileUrl,
    };
    await _usersCollection.doc(profile.id).update(updatedProfilePic);
  }

  // getter
  static CollectionReference get usersCollection => _usersCollection;
  static User? get currentUser => _currentUser;
}
