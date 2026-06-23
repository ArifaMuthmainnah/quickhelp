import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'admin_request_detail_screen.dart';

class AdminRequestScreen extends StatefulWidget {
  const AdminRequestScreen({super.key});

  @override
  State<AdminRequestScreen> createState() =>
      _AdminRequestScreenState();
}

class _AdminRequestScreenState
    extends State<AdminRequestScreen> {
  String search = "";
  String filterStatus = "Semua";

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

  Future<void> hapusRequest(String id) async {
    await FirebaseFirestore.instance
        .collection("requests")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Kelola Permintaan"),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration:
                        InputDecoration(
                      hintText:
                          "Cari permintaan...",
                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),
                      filled: true,
                      fillColor:
                          Colors.white,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    18),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    children: [
                      filterButton(
                        "Semua",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      filterButton(
                        "Aktif",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      filterButton(
                        "Selesai",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot>(
                stream:
                    FirebaseFirestore
                        .instance
                        .collection(
                            "requests")
                        .orderBy(
                          "createdAt",
                          descending:
                              true,
                        )
                        .snapshots(),
                builder: (context,
                    snapshot) {
                  if (!snapshot
                      .hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot
                      .data!.docs
                      .where((doc) {
                    final data =
                        doc.data()
                            as Map<String,
                                dynamic>;

                    final matchSearch =
                        search
                                .isEmpty ||
                            data["title"]
                                .toString()
                                .toLowerCase()
                                .contains(
                                  search
                                      .toLowerCase(),
                                );

                    final matchStatus =
                        filterStatus ==
                                "Semua" ||
                            data["status"] ==
                                filterStatus;

                    return matchSearch &&
                        matchStatus;
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada permintaan.",
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 20,
                    ),
                    itemCount:
                        docs.length,
                    itemBuilder:
                        (_, index) {
                      final doc =
                          docs[index];

                      final data =
                          doc.data()
                              as Map<String,
                                  dynamic>;

                      return Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 18,
                        ),
                        padding:
                            const EdgeInsets
                                .all(18),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha:
                                    0.05,
                              ),
                              blurRadius:
                                  10,
                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
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
                                    vertical:
                                        5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: AppColors
                                        .primary
                                        .withValues(
                                      alpha:
                                          0.15,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: Text(
                                    data[
                                        "category"],
                                    style:
                                        const TextStyle(
                                      color:
                                          AppColors.primary,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        12,
                                    vertical:
                                        5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: statusColor(
                                            data[
                                                "status"])
                                        .withValues(
                                      alpha:
                                          0.15,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: Text(
                                    data[
                                        "status"],
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
                              height: 15,
                            ),

                            Text(
                              data["title"],
                              style:
                                  const TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              data[
                                  "description"],
                              maxLines: 3,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .card_giftcard,
                                  size: 18,
                                  color: Colors
                                      .grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data["reward"] ??
                                      "-",
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                      OutlinedButton(
                                    onPressed:
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  AdminRequestDetailScreen(
                                            id: doc
                                                .id,
                                            data:
                                                data,
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        const Text(
                                      "Lihat Detail",
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                      ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                    onPressed:
                                        () async {
                                      await hapusRequest(
                                        doc.id,
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
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text) {
    final selected =
        filterStatus == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          filterStatus = text;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
                  20),
          border: Border.all(
            color: AppColors.primary,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : AppColors.primary,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}