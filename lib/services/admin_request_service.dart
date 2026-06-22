import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequestService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllRequests() {
    return firestore
        .collection("requests")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();
  }

  Future<void> completeRequest(
      String id) async {
    await firestore
        .collection("requests")
        .doc(id)
        .update({
      "status": "Selesai",
    });
  }

  Future<void> deleteRequest(
      String id) async {
    await firestore
        .collection("requests")
        .doc(id)
        .delete();
  }

  Future<void> updateRequest({
    required String id,
    required String title,
    required String description,
    required String category,
    required String reward,
    required String location,
  }) async {
    await firestore
        .collection("requests")
        .doc(id)
        .update({
      "title": title,
      "description": description,
      "category": category,
      "reward": reward,
      "location": location,
    });
  }
}