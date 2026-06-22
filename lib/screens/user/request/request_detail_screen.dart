import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/request_service.dart';
import '../../../theme/app_colors.dart';
import '../chat/chat_screen.dart';
import '../report/report_screen.dart';
import 'edit_request_screen.dart';

class RequestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const RequestDetailScreen({
    super.key,
    required this.data,
  });

  @override
  State<RequestDetailScreen> createState() =>
      _RequestDetailScreenState();
}

class _RequestDetailScreenState
    extends State<RequestDetailScreen> {
  Widget badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoCard(
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = RequestService();
    final data = widget.data;

    final currentUid =
        FirebaseAuth.instance.currentUser!.uid;

    final isMyRequest =
        data["uid"] == currentUid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Detail Permintaan"),
        actions: !isMyRequest
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.flag_outlined,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,                       
                      MaterialPageRoute(
                        builder: (_) => ReportScreen(
                        reportedId: (data["uid"] ?? "").toString(),
                        reportedName: (data["userName"] ?? "Mahasiswa").toString(),
                        requestId: (data["docId"] ?? "").toString(),
                        requestTitle: (data["title"] ?? "-").toString(),
                      ),
                      ),
                    );
                  },
                ),
              ]
            : [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              badge(
                data["category"] ?? "-",
                AppColors.primary,
              ),
              const SizedBox(width: 8),
              badge(
                (data["status"] ?? "-").toString(),
                Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            data["title"] ?? "-",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            data["userName"] ?? "Mahasiswa",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              infoCard(
                "MASA BERLAKU",
                data["deadline"] ?? "-",
              ),
              const SizedBox(width: 12),
              infoCard(
                "DURASI",
                data["duration"] ?? "-",
              ),
              const SizedBox(width: 12),
              infoCard(
                "IMBALAN",
                data["reward"] ?? "-",
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Deskripsi Lengkap",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Text(
              (data["description"] ?? "-").toString()
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Lokasi Pertemuan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    (data["location"] ?? "-").toString(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // REQUEST ORANG LAIN
          if (!isMyRequest)
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId:
                            "${FirebaseAuth.instance.currentUser!.uid}_${data["uid"]}",
                        userName: (data["userName"] ?? "Mahasiswa").toString(),
                        whatsapp: (data["whatsapp"] ?? "").toString(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "BANTU SEKARANG",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          // REQUEST SENDIRI
          if (isMyRequest)
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditRequestScreen(
                       data: data,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "EDIT PERMINTAAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (isMyRequest)
            const SizedBox(height: 15),

          if (isMyRequest)
            SizedBox(
              height: 55,
              child: OutlinedButton(
                onPressed: () async {
                  await service.updateStatus(
                    docId: data["docId"],
                    status: "Selesai",
                  );
                  await FirebaseFirestore.instance
                      .collection("notifications")
                      .add({
                    "uid": data["uid"],
                    "title": "Permintaan Selesai",
                    "description":
                        "Permintaan ${data["title"]} telah selesai",
                    "createdAt": Timestamp.now(),
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "TANDAI SELESAI",
                ),
              ),
            ),

          if (isMyRequest)
            const SizedBox(height: 15),

          if (isMyRequest)
            SizedBox(
              height: 55,
              child: TextButton(
                onPressed: () async {
                  await service.deleteRequest(
                    data["docId"],
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "BATALKAN PERMINTAAN",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}