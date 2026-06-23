import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class ReportDetailScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const ReportDetailScreen({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  State<ReportDetailScreen> createState() =>
      _ReportDetailScreenState();
}

class _ReportDetailScreenState
    extends State<ReportDetailScreen> {
  final firestore =
      FirebaseFirestore.instance;

  Color statusColor(String status) {
    switch (status) {
      case "Menunggu":
        return Colors.orange;
      case "Diproses":
        return Colors.blue;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> updateReport(
    String status,
    String title,
  ) async {
    await firestore
        .collection("reports")
        .doc(widget.id)
        .update({
      "status": status,
      "progress": FieldValue.arrayUnion([
        {
          "title": title,
          "time": Timestamp.now(),
        }
      ])
    });

    setState(() {
      widget.data["status"] = status;

      (widget.data["progress"] as List).add({
        "title": title,
        "time": Timestamp.now(),
      });
    });
  }

  Future<void> disableUser() async {
    await firestore
        .collection("users")
        .doc(widget.data["reportedId"])
        .update({
      "accountStatus": "Nonaktif"
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Akun berhasil dinonaktifkan",
        ),
      ),
    );
  }

  String formatDate(Timestamp? ts) {
    if (ts == null) return "-";

    final d = ts.toDate();

    return "${d.day}/${d.month}/${d.year} • ${d.hour}:${d.minute.toString().padLeft(2, "0")}";
  }

  Widget infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    final List progress =
        data["progress"] ?? [];

    final List evidences =
        data["evidences"] ?? [];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Detail Laporan",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ID: ${widget.id}",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(
                            data["status"])
                        .withValues(
                      alpha: 0.15,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Text(
                    data["status"],
                    style: TextStyle(
                      color: statusColor(
                        data["status"],
                      ),
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            infoCard(
              Icons.person,
              "Pelapor",
              data["reporterName"] ?? "-",
            ),

            infoCard(
              Icons.report_problem,
              "Terlapor",
              data["reportedName"] ?? "-",
            ),

            infoCard(
              Icons.assignment,
              "Permintaan",
              data["requestTitle"] ?? "-",
            ),

            const SizedBox(height: 25),

            const Text(
              "Kronologi Laporan",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alasan: ${data["reason"]}",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    data["description"] ??
                        "-",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Progress Penanganan",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...progress.map((item) {
              final map =
                  Map<String, dynamic>.from(
                item,
              );

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                padding:
                    const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            map["title"],
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Text(
                            formatDate(
                              map["time"],
                            ),
                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            const Text(
              "Bukti Laporan",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            evidences.isEmpty
                ? const Text(
                    "Tidak ada lampiran",
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        evidences.map<Widget>(
                      (url) {
                        return ClipRRect(
                          borderRadius:
                              BorderRadius
                                  .circular(14),
                          child:
                              Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ).toList(),
                  ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),
                onPressed: () {
                  updateReport(
                    data["status"],
                    "Peringatan diberikan kepada pengguna",
                  );
                },
                icon: const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                label: const Text(
                  "Beri Peringatan",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                ),
                onPressed: disableUser,
                icon: const Icon(
                  Icons.person_off,
                  color: Colors.white,
                ),
                label: const Text(
                  "Nonaktifkan Akun",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                ),
                onPressed: () {
                  updateReport(
                    "Selesai",
                    "Laporan telah diselesaikan",
                  );
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: const Text(
                  "Selesaikan Laporan",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}