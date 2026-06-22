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

  Future<void> updateReport(
      String status,
      String title) async {
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
        content:
            Text("Akun berhasil dinonaktifkan"),
      ),
    );
  }

  String formatDate(Timestamp? ts) {
    if (ts == null) return "-";

    final d = ts.toDate();

    return "${d.day}/${d.month}/${d.year}  ${d.hour}:${d.minute.toString().padLeft(2, "0")}";
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

            /// ID
            Text(
              "ID Laporan",

              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            Text(
              widget.id,

              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 25),

            _infoCard(
              "Pelapor",
              data["reporterName"] ??
                  "-",
            ),

            const SizedBox(height: 15),

            _infoCard(
              "Terlapor",
              data["reportedName"] ??
                  "-",
            ),

            const SizedBox(height: 15),

            _infoCard(
              "Permintaan",
              data["requestTitle"] ??
                  "-",
            ),

            const SizedBox(height: 30),

            const Text(
              "Tahapan Laporan",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(15),

                child: Column(
                  children:
                      progress.map((item) {

                    final map =
                        Map<String,
                                dynamic>.from(
                            item);

                    return ListTile(
                      leading:
                          const Icon(
                        Icons
                            .check_circle,

                        color: Colors.green,
                      ),

                      title: Text(
                        map["title"],
                      ),

                      subtitle: Text(
                        formatDate(
                          map["time"],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Kronologi",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      "Alasan : ${data["reason"]}",
                    ),

                    const SizedBox(height: 12),

                    Text(
                      data["description"] ??
                          "-",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Bukti Laporan",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            evidences.isEmpty
                ? const Text(
                    "Tidak ada lampiran")
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: evidences
                        .map<Widget>(
                            (url) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context:
                                context,

                            builder: (_) {
                              return Dialog(
                                child:
                                    InteractiveViewer(
                                  child:
                                      Image.network(
                                    url,
                                  ),
                                ),
                              );
                            },
                          );
                        },

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      12),

                          child:
                              Image.network(
                            url,

                            width: 100,

                            height: 100,

                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.warning,
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),

                onPressed: () {

                  updateReport(
                    widget.data["status"],
                    "Peringatan diberikan kepada pengguna",
                  );

                },

                label: const Text(
                  "Beri Peringatan",
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.person_off,
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                ),

                onPressed: disableUser,

                label: const Text(
                  "Nonaktifkan Akun",
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.check,
                ),

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

                label: const Text(
                  "Selesaikan Laporan",
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}