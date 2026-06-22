import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> submitReport({
    required String reporterId,
    required String reporterName,

    required String reportedId,
    required String reportedName,

    required String requestId,
    required String requestTitle,

    required String reason,
    required String description,

    required List<String> evidences,
  }) async {
    await firestore.collection("reports").add({
      "reporterId": reporterId,
      "reporterName": reporterName,

      "reportedId": reportedId,
      "reportedName": reportedName,

      "requestId": requestId,
      "requestTitle": requestTitle,

      "reason": reason,
      "description": description,

      "evidences": evidences,

      "status": "Menunggu",

      "progress": [
        {
          "title": "Laporan diterima",
          "time": Timestamp.now(),
        }
      ],

      "createdAt": Timestamp.now(),
    });

    await firestore.collection("notifications").add({
      "uid": "admin",
      "title": "Laporan Baru",
      "description":
          "$reporterName melaporkan $reportedName",
      "createdAt": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getReports() {
    return firestore
        .collection("reports")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();
  }

  Future<void> updateStatus({
    required String reportId,
    required String status,
    required String progressTitle,
  }) async {
    await firestore
        .collection("reports")
        .doc(reportId)
        .update({
      "status": status,
      "progress": FieldValue.arrayUnion([
        {
          "title": progressTitle,
          "time": Timestamp.now(),
        }
      ]),
    });
  }

  Future<void> nonaktifkanUser(
      String userId) async {
    await firestore
        .collection("users")
        .doc(userId)
        .update({
      "accountStatus": "Nonaktif",
    });
  }

  Future<void> beriPeringatan(
      String reportId) async {
    await firestore
        .collection("reports")
        .doc(reportId)
        .update({
      "progress": FieldValue.arrayUnion([
        {
          "title":
              "Peringatan dikirim kepada pengguna",
          "time": Timestamp.now(),
        }
      ]),
    });
  }
}