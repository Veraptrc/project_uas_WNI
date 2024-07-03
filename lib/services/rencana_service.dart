import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wni/models/rencana.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/services/profile_service.dart';

class RencanaService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _rencanaCollection =
      _database.collection('rencana');
  static final CollectionReference _wisataCollection =
      _database.collection('wisata');

  static Stream<List<Rencana>> getRencanaStream() {
    return _rencanaCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Rencana(
          id: doc.id,
          waktuBerangkat: (data['waktuBerangkat'] as Timestamp).toDate(),
          wisataId: data['wisata'],
          userId: data['userId'],
        );
      }).toList();
    });
  }

  static Future<List<Rencana>> getRencanaList() async {
    QuerySnapshot snapshot = await _rencanaCollection
        .where("userId", isEqualTo: ProfileService.currentUser!.uid)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Rencana(
        id: doc.id,
        waktuBerangkat: (data['waktuBerangkat'] as Timestamp).toDate(),
        wisataId: data['wisata'],
        userId: data['userId'],
      );
    }).toList();
  }

  static Future<Wisata?> getWisataById(String id) async {
    DocumentSnapshot doc = await _wisataCollection.doc(id).get();
    if (doc.exists) {
      return Wisata.fromSnapshot(doc);
    } else {
      return null; // or throw an exception
    }
  }

  static Future<void> addRencana(Rencana rencana) async {
    Map<String, dynamic> newRencana = {
      'waktuBerangkat': rencana.waktuBerangkat,
      'wisata': rencana.wisataId,
      'userId': rencana.userId,
    };
    await _rencanaCollection.add(newRencana);
  }

  static Future<void> deleteRencana(Rencana rencana) async {
    await _rencanaCollection.doc(rencana.id).delete();
  }
}
