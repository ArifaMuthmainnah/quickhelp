import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'admin_request_detail_screen.dart';

class AdminRequestScreen extends StatelessWidget {
  const AdminRequestScreen({super.key});

  Color statusColor(String status) {
    switch (status) {
      case "Aktif":
        return Colors.orange;

      case "Diproses":
        return Colors.blue;

      case "Selesai":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  Future hapusRequest(String id) async {
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
        title: const Text(
          "Kelola Permintaan",
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("requests")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada permintaan.",
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.all(20),

            itemCount: docs.length,

            itemBuilder: (_, index) {

              final doc = docs[index];

              final data =
                  doc.data() as Map<String, dynamic>;

              return Card(

                margin:
                    const EdgeInsets.only(
                  bottom: 18,
                ),

                elevation: 1,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                          18),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Row(

                        children: [

                          Expanded(

                            child: Text(

                              data["title"],

                              style:
                                  const TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 18,

                              ),

                            ),

                          ),

                          Container(

                            padding:
                                const EdgeInsets.symmetric(

                              horizontal: 12,

                              vertical: 5,

                            ),

                            decoration:
                                BoxDecoration(

                              color: statusColor(
                                data["status"],
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                      20),

                            ),

                            child: Text(

                              data["status"],

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,

                              ),

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 12),

                      Text(
                        data["description"],
                        maxLines: 3,
                        overflow:
                            TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 15),

                      Wrap(

                        spacing: 10,

                        runSpacing: 8,

                        children: [

                          Chip(
                            label: Text(
                              data["category"],
                            ),
                          ),

                          Chip(
                            label: Text(
                              data["reward"],
                            ),
                          ),

                        ],

                      ),

                      const SizedBox(height: 20),

                      Row(

                        children: [

                          Expanded(

                            child:
                                OutlinedButton(

                              onPressed: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        AdminRequestDetailScreen(
                                      id: doc.id,
                                      data: data,
                                    ),

                                  ),

                                );

                              },

                              child: const Text(
                                "Lihat Detail",
                              ),

                            ),

                          ),

                          const SizedBox(width: 12),

                          Expanded(

                            child:
                                ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(

                                backgroundColor:
                                    Colors.red,

                              ),

                              onPressed: () {

                                showDialog(

                                  context: context,

                                  builder: (_) =>
                                      AlertDialog(

                                    title: const Text(
                                      "Hapus Permintaan",
                                    ),

                                    content:
                                        const Text(
                                      "Yakin ingin menghapus permintaan ini?",
                                    ),

                                    actions: [

                                      TextButton(

                                        onPressed: () {

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

                                          await hapusRequest(
                                            doc.id,
                                          );

                                          if (context
                                              .mounted) {
                                            Navigator.pop(
                                                context);
                                          }

                                        },

                                        child:
                                            const Text(
                                          "Hapus",
                                          style:
                                              TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),

                                      ),

                                    ],

                                  ),

                                );

                              },

                              child: const Text(

                                "Hapus",

                                style: TextStyle(
                                  color: Colors.white,
                                ),

                              ),

                            ),

                          ),

                        ],

                      )

                    ],

                  ),

                ),

              );

            },

          );

        },

      ),

    );

  }

}