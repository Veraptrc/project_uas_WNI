import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wni/models/notifikasi.dart';

class NotificationService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _notifikasiCollection =
      _database.collection('notifikasi');

  static Stream<List<Notifikasi>> getNotifikasiList() {
    return _notifikasiCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Notifikasi(
          id: data["id"],
          judul: data["judul"],
          pesan: data["pesan"],
        );
      }).toList();
    });
  }
}
