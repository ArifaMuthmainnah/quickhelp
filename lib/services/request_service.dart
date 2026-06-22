import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  // ==========================
  // TAMBAH REQUEST
  // ==========================

  Future<void> addRequest({
    required String title,
    required String description,
    required String category,
    required String reward,
    required String deadline,
    required String duration,
    required String location,
    required String fileUrl,
  }) async {
    final user = auth.currentUser;

    if (user == null) return;

    final userDoc = await firestore
        .collection("users")
        .doc(user.uid)
        .get();

    final data = userDoc.data();

    await firestore.collection("requests").add({
      "uid": user.uid,
      "userName":
          data?["name"] ?? "Mahasiswa",
      "userEmail":
          data?["email"] ?? "",
      "title": title,
      "description": description,
      "category": category,
      "reward": reward,
      "deadline": deadline,
      "duration": duration,
      "location": location,
      "fileUrl": fileUrl,
      "status": "Aktif",
      "createdAt":
          FieldValue.serverTimestamp(),
    });

    await firestore.collection("notifications").add({
      "uid": "all",
      "title": "Permintaan Baru",
      "description":
          "${data?["name"] ?? "Mahasiswa"} membuat permintaan bantuan baru",
      "createdAt": Timestamp.now(),
    });
  }

  // ==========================
  // SEMUA REQUEST (beranda & bantu)
  // hanya request orang lain
  // ==========================

  Stream<QuerySnapshot> getRequests({
    String category = "Semua",
    String search = "",
  }) {
    return firestore
        .collection("requests")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();
  }

  // ==========================
  // REQUEST SAYA (riwayat)
  // ==========================

  Stream<QuerySnapshot> getMyRequests() {
    final user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection("requests")
        .where(
          "uid",
          isEqualTo: user.uid,
        )
        .snapshots();
  }

  // ==========================
  // UPDATE STATUS
  // ==========================

  Future<void> updateStatus({
    required String docId,
    required String status,
  }) async {
    await firestore
        .collection("requests")
        .doc(docId)
        .update({
      "status": status,
    });
  }

  // ==========================
  // HAPUS REQUEST
  // ==========================

  Future<void> deleteRequest(
      String docId) async {
    await firestore
        .collection("requests")
        .doc(docId)
        .delete();
  }

  // ==========================
  // DETAIL REQUEST
  // ==========================

  Future<DocumentSnapshot> getRequest(
      String id) async {
    return await firestore
        .collection("requests")
        .doc(id)
        .get();
  }
}