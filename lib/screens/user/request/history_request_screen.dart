import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/request_service.dart';
import '../../../theme/app_colors.dart';
import 'request_detail_screen.dart';

class HistoryRequestScreen extends StatefulWidget {
  const HistoryRequestScreen({
    super.key,
  });

  @override
  State<HistoryRequestScreen> createState() =>
      _HistoryRequestScreenState();
}

class _HistoryRequestScreenState
    extends State<HistoryRequestScreen> {
  final service = RequestService();

  String selectedFilter = "Semua";

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "aktif":
        return Colors.green;
      case "selesai":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget filterChip(String label) {
    final selected =
        selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          right: 10,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Riwayat Permintaan",
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          // FILTER
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection:
                  Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              children: [
                filterChip("Semua"),
                filterChip("Aktif"),
                filterChip("Selesai"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child:
                StreamBuilder<QuerySnapshot>(
              stream: service.getMyRequests(),
              builder:
                  (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error
                          .toString(),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs
                        .isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada riwayat permintaan.",
                    ),
                  );
                }

                final docs = snapshot
                    .data!.docs
                    .where((doc) {
                  final data = doc.data()
                      as Map<String,
                          dynamic>;

                  if (selectedFilter ==
                      "Semua") {
                    return true;
                  }

                  return (data["status"] ??
                              "")
                          .toString()
                          .toLowerCase() ==
                      selectedFilter
                          .toLowerCase();
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data sesuai filter.",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(
                          20),
                  itemCount: docs.length,
                  itemBuilder:
                      (context, index) {
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
                            color: Colors.black
                                .withValues(
                                    alpha:
                                        0.05),
                            blurRadius: 10,
                            offset:
                                const Offset(
                                    0, 4),
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
                                              0.15),
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
                                          data["status"])
                                      .withValues(
                                          alpha:
                                              0.15),
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  data["status"] ??
                                      "-",
                                  style:
                                      TextStyle(
                                    color: statusColor(
                                        data["status"]),
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 15),

                          Text(
                            data["title"] ??
                                "-",
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Text(
                            data["description"] ??
                                "-",
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                TextStyle(
                              color: Colors
                                  .grey[700],
                            ),
                          ),

                          const SizedBox(
                              height: 15),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .location_on,
                                size: 18,
                                color:
                                    Colors.grey,
                              ),
                              const SizedBox(
                                  width: 6),
                              Expanded(
                                child: Text(
                                  data["location"] ??
                                      "-",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 20),

                          SizedBox(
                            width:
                                double.infinity,
                            height: 48,
                            child:
                                ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors
                                        .primary,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            RequestDetailScreen(
                                      data: {
                                        ...data,
                                        "docId":
                                            doc.id,
                                      },
                                    ),
                                  ),
                                );
                              },
                              child:
                                  const Text(
                                "Lihat Detail",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
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
    );
  }
}