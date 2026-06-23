import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../announcement/create_announcement_screen.dart';
import '../category/category_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() =>
      _AdminHomeScreenState();
}

class _AdminHomeScreenState
    extends State<AdminHomeScreen> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>
      getAdmin() {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots();
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activityCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

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

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),
                child: Text(
                  data["category"] ?? "-",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight:
                        FontWeight.w600,
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
                decoration: BoxDecoration(
                  color: statusColor(
                          data["status"])
                      .withValues(
                          alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),
                child: Text(
                  data["status"] ?? "-",
                  style: TextStyle(
                    color: statusColor(
                        data["status"]),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            data["title"] ?? "-",
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            data["description"] ?? "-",
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: StreamBuilder(
        stream: getAdmin(),
        builder: (context, adminSnapshot) {
          if (!adminSnapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final admin =
              adminSnapshot.data!.data()!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore
                .instance
                .collection("users")
                .snapshots(),
            builder: (context, userSnapshot) {
              return StreamBuilder<
                  QuerySnapshot>(
                stream: FirebaseFirestore
                    .instance
                    .collection(
                        "requests")
                    .snapshots(),
                builder:
                    (context, requestSnapshot) {
                  return StreamBuilder<
                      QuerySnapshot>(
                    stream: FirebaseFirestore
                        .instance
                        .collection(
                            "reports")
                        .snapshots(),
                    builder: (context,
                        reportSnapshot) {
                      if (!userSnapshot
                              .hasData ||
                          !requestSnapshot
                              .hasData ||
                          !reportSnapshot
                              .hasData) {
                        return const Center(
                          child:
                              CircularProgressIndicator(),
                        );
                      }

                      final users =
                          userSnapshot
                              .data!.docs;

                      final requests =
                          requestSnapshot
                              .data!.docs;

                      final reports =
                          reportSnapshot
                              .data!.docs;

                      int aktif = 0;

                      for (var r in requests) {
                        if (r["status"] ==
                            "Aktif") {
                          aktif++;
                        }
                      }

                      return SingleChildScrollView(
                        padding:
                            const EdgeInsets.all(
                                20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      AppColors
                                          .primary,
                                  backgroundImage:
                                      (admin["photoUrl"] !=
                                                  null &&
                                              admin["photoUrl"] !=
                                                  "")
                                          ? NetworkImage(
                                              admin["photoUrl"])
                                          : null,
                                  child: (admin["photoUrl"] ==
                                              null ||
                                          admin["photoUrl"] ==
                                              "")
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors
                                              .white,
                                        )
                                      : null,
                                ),

                                const SizedBox(
                                    width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      const Text(
                                        "Halo Admin 👋",
                                        style:
                                            TextStyle(
                                          fontSize:
                                              15,
                                          color: Colors
                                              .grey,
                                        ),
                                      ),
                                      Text(
                                        admin["name"],
                                        style:
                                            const TextStyle(
                                          fontSize:
                                              22,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 30),

                            const Text(
                              "Ringkasan Statistik",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            Row(
                              children: [
                                statCard(
                                  title:
                                      "Total User",
                                  value: users
                                      .length
                                      .toString(),
                                  icon:
                                      Icons.people,
                                  color:
                                      Colors.blue,
                                ),

                                statCard(
                                  title:
                                      "Permintaan\nAktif",
                                  value: aktif
                                      .toString(),
                                  icon: Icons
                                      .assignment,
                                  color:
                                      AppColors
                                          .primary,
                                ),

                                statCard(
                                  title:
                                      "Laporan\nMasuk",
                                  value: reports
                                      .length
                                      .toString(),
                                  icon: Icons
                                      .report_problem,
                                  color:
                                      Colors.red,
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 28),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                      ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.category,
                                      color: Colors
                                          .white,
                                    ),
                                    label:
                                        const Text(
                                      "Kelola Kategori",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors
                                              .deepPurple,
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical:
                                            16,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const CategoryScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                    width: 15),

                                Expanded(
                                  child:
                                      ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.campaign,
                                      color: Colors
                                          .white,
                                    ),
                                    label:
                                        const Text(
                                      "Kirim Pengumuman",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.green,
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical:
                                            16,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const CreateAnnouncementScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 30),

                            const Text(
                              "Aktivitas Terbaru",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(
                                height: 15),

                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount:
                                  requests.length > 5
                                      ? 5
                                      : requests
                                          .length,
                              itemBuilder:
                                  (context,
                                      index) {
                                return activityCard(
                                  requests[index],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}