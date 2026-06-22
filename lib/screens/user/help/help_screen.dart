import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../theme/app_colors.dart';
import '../../../services/request_service.dart';
import '../request/request_detail_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() =>
      _HelpScreenState();
}

class _HelpScreenState
    extends State<HelpScreen> {
  final service = RequestService();

  final searchController =
      TextEditingController();

  String kategori = "Semua";

  final kategoriList = [
    "Semua",
    "Akademik",
    "Barang",
    "Sosial",
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Beri Bantuan"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Cari bantuan",
                    prefixIcon:
                        const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal,
                    itemCount:
                        kategoriList.length,
                    itemBuilder: (_, index) {
                      final item =
                          kategoriList[index];

                      final aktif =
                          item == kategori;

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          right: 10,
                        ),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: aktif,
                          onSelected: (_) {
                            setState(() {
                              kategori = item;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: service.getRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                var docs = snapshot.data!.docs;

                docs = docs.where((doc) {
                  final data =
                      doc.data()
                          as Map<String, dynamic>;

                  final title =
                      data["title"]
                          .toString()
                          .toLowerCase();

                  final category =
                      data["category"];

                  final cocokKategori =
                      kategori == "Semua"
                          ? true
                          : category == kategori;

                  final cocokSearch =
                      title.contains(
                    searchController.text
                        .toLowerCase(),
                  );

                  final notMyRequest =
                      data["uid"] !=
                          FirebaseAuth
                              .instance
                              .currentUser!
                              .uid;

                  return cocokKategori &&
                      cocokSearch &&
                      notMyRequest;
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
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (_, index) {
                    final doc = docs[index];
                    final data =
                        doc.data()
                            as Map<String, dynamic>;

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 18,
                      ),
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset:
                                const Offset(0, 4),
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
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: AppColors
                                      .primary
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  data["category"],
                                  style: TextStyle(
                                    color: AppColors
                                        .primary,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: statusColor(
                                          data[
                                              "status"])
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  data["status"],
                                  style: TextStyle(
                                    color:
                                        statusColor(
                                      data[
                                          "status"],
                                    ),
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 15),

                          Text(
                            data["title"],
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Text(
                            data["description"],
                            maxLines: 3,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style: TextStyle(
                              color:
                                  Colors.grey[700],
                            ),
                          ),

                          const SizedBox(
                              height: 18),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                  width: 5),
                              Expanded(
                                child: Text(
                                  data["location"] ??
                                      "-",
                                  style:
                                      const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 8),

                          Row(
                            children: [
                              const Icon(
                                Icons.card_giftcard,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                  width: 5),
                              Text(
                                data["reward"] ??
                                    "-",
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 20),

                          SizedBox(
                            width: double.infinity,
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
                                    builder: (_) =>
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
                              child: const Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ),
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