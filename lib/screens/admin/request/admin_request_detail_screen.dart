import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class AdminRequestDetailScreen
    extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const AdminRequestDetailScreen({
    super.key,
    required this.id,
    required this.data,
  });

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "aktif":
        return Colors.green;
      case "diproses":
        return Colors.orange;
      case "selesai":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                18),
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
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> hapusRequest(
    BuildContext context,
  ) async {
    await FirebaseFirestore
        .instance
        .collection(
            "requests")
        .doc(id)
        .delete();

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Detail Permintaan",
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(
                20),
        children: [
          Container(
            padding:
                const EdgeInsets
                    .all(20),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius
                      .circular(22),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            12,
                        vertical: 6,
                      ),
                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.15,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),
                      child: Text(
                        data["category"] ??
                            "-",
                        style:
                            const TextStyle(
                          color:
                              AppColors.primary,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                        width: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            12,
                        vertical: 6,
                      ),
                      decoration:
                          BoxDecoration(
                        color: statusColor(
                                data[
                                    "status"])
                            .withValues(
                          alpha: 0.15,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),
                      child: Text(
                        data["status"] ??
                            "-",
                        style:
                            TextStyle(
                          color:
                              statusColor(
                            data[
                                "status"],
                          ),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 20),

                Text(
                  data["title"] ??
                      "-",
                  style:
                      const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 15),

                const Text(
                  "Deskripsi",
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                    height: 10),

                Text(
                  data["description"] ??
                      "-",
                ),
              ],
            ),
          ),

          const SizedBox(
              height: 25),

          infoTile(
            Icons.location_on,
            "Lokasi",
            data["location"] ??
                "-",
          ),

          infoTile(
            Icons.card_giftcard,
            "Reward",
            data["reward"] ??
                "-",
          ),

          infoTile(
            Icons.schedule,
            "Durasi Bantuan",
            data["duration"] ??
                "-",
          ),

          infoTile(
            Icons.timer,
            "Masa Berlaku",
            data["deadline"] ??
                "-",
          ),

          infoTile(
            Icons.person,
            "Pembuat",
            data["userName"] ??
                "Mahasiswa",
          ),

          const SizedBox(
              height: 30),

          SizedBox(
            height: 55,
            child:
                ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: const Text(
                "Hapus Permintaan",
                style: TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              onPressed: () {
                showDialog(
                  context:
                      context,
                  builder: (_) =>
                      AlertDialog(
                    title:
                        const Text(
                      "Hapus Permintaan",
                    ),
                    content:
                        const Text(
                      "Permintaan ini akan dihapus permanen.",
                    ),
                    actions: [
                      TextButton(
                        onPressed:
                            () {
                          Navigator.pop(
                              context);
                        },
                        child:
                            const Text(
                          "Batal",
                        ),
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                        ),
                        onPressed:
                            () async {
                          Navigator.pop(
                              context);
                          await hapusRequest(
                            context,
                          );
                        },
                        child:
                            const Text(
                          "Hapus",
                          style:
                              TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}