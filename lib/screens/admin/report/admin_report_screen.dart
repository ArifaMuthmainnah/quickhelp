import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'admin_report_detail_screen.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() =>
      _AdminReportScreenState();
}

class _AdminReportScreenState
    extends State<AdminReportScreen> {
  String filter = "Semua";

  final searchController =
      TextEditingController();

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

  String formatDate(Timestamp? time) {
    if (time == null) return "-";

    final date = time.toDate();

    return
        "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Kelola Laporan",
        ),
      ),

      body: Column(
        children: [

          /// SEARCH + FILTER
          Padding(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              children: [

                TextField(
                  controller:
                      searchController,

                  decoration:
                      InputDecoration(
                    hintText:
                        "Cari nama pelapor / terlapor",

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
                          BorderRadius.circular(
                              15),
                    ),
                  ),

                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal,

                  child: Row(
                    children: [

                      ChoiceChip(
                        label:
                            const Text(
                                "Semua"),

                        selected:
                            filter ==
                                "Semua",

                        onSelected:
                            (_) {
                          setState(() {
                            filter =
                                "Semua";
                          });
                        },
                      ),

                      const SizedBox(
                          width: 10),

                      ChoiceChip(
                        label:
                            const Text(
                                "Menunggu"),

                        selected:
                            filter ==
                                "Menunggu",

                        onSelected:
                            (_) {
                          setState(() {
                            filter =
                                "Menunggu";
                          });
                        },
                      ),

                      const SizedBox(
                          width: 10),

                      ChoiceChip(
                        label:
                            const Text(
                                "Diproses"),

                        selected:
                            filter ==
                                "Diproses",

                        onSelected:
                            (_) {
                          setState(() {
                            filter =
                                "Diproses";
                          });
                        },
                      ),

                      const SizedBox(
                          width: 10),

                      ChoiceChip(
                        label:
                            const Text(
                                "Selesai"),

                        selected:
                            filter ==
                                "Selesai",

                        onSelected:
                            (_) {
                          setState(() {
                            filter =
                                "Selesai";
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
                StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection(
                          "reports")
                      .orderBy(
                        "createdAt",
                        descending:
                            true,
                      )
                      .snapshots(),

              builder:
                  (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                List docs =
                    snapshot.data!.docs;

                docs = docs.where((doc) {
                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  final keyword =
                      searchController
                          .text
                          .toLowerCase();

                  final reporter =
                      (data["reporterName"] ??
                              "")
                          .toString()
                          .toLowerCase();

                  final reported =
                      (data["reportedName"] ??
                              "")
                          .toString()
                          .toLowerCase();

                  final reason =
                      (data["reason"] ?? "")
                      .toString()
                      .toLowerCase();

                  final status =
                      (data["status"] ??
                              "")
                          .toString();

                  final cocokSearch =
                        reporter.contains(keyword) ||
                        reported.contains(keyword) ||
                        reason.contains(keyword);

                  final cocokFilter =
                      filter ==
                              "Semua" ||
                          status ==
                              filter;

                  return cocokSearch &&
                      cocokFilter;
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada laporan",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    20,
                    0,
                    20,
                    20,
                  ),

                  itemCount:
                      docs.length,

                  itemBuilder:
                      (context, index) {
                    final report =
                        docs[index];

                    final data =
                        report.data()
                            as Map<String,
                                dynamic>;

                    return Card(
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 18,
                      ),

                      elevation: 1,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    18),
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets
                                .all(18),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Row(
                              children: [

                                Expanded(
                                  child:
                                      Text(
                                    data["reportedName"] ??
                                        "-",

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,

                                      fontSize:
                                          18,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        10,

                                    vertical:
                                        5,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        statusColor(
                                      data["status"],
                                    ),

                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),

                                  child:
                                      Text(
                                    data["status"],

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                                height:
                                    12),

                            Text(
                              "Pelapor : ${data["reporterName"]}",
                            ),

                            const SizedBox(
                                height:
                                    5),

                            Text(
                              "Alasan : ${data["reason"]}",
                            ),

                            const SizedBox(
                                height:
                                    5),

                            Text(
                              "Permintaan : ${data["requestTitle"] ?? "-"}",
                            ),

                            const SizedBox(
                                height:
                                    5),

                            Text(
                              formatDate(
                                data["createdAt"],
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    Colors.grey,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    18),

                            SizedBox(
                              width: double
                                  .infinity,

                              child:
                                  ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primary,
                                ),

                                child:
                                    const Text(
                                  "Lihat Detail",
                                ),

                                onPressed:
                                    () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              ReportDetailScreen(
                                        id: report
                                            .id,

                                        data:
                                            data,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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