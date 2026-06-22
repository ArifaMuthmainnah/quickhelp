import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../announcement/create_announcement_screen.dart';
import '../category/category_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),

            const SizedBox(height: 5),

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

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppColors.primary.withValues(alpha: 0.15),
          child: const Icon(
            Icons.assignment,
            color: AppColors.primary,
          ),
        ),

        title: Text(
          data["title"] ?? "-",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Text(
          data["category"] ?? "-",
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Text(
            data["status"] ?? "-",
            style: const TextStyle(
              color: Colors.white,
            ),
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
        title: const Text("Dashboard Admin"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),
        builder: (context, userSnapshot) {

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("requests")
                .snapshots(),
            builder: (context, requestSnapshot) {

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("reports")
                    .snapshots(),
                builder: (context, reportSnapshot) {

                  if (!userSnapshot.hasData ||
                      !requestSnapshot.hasData ||
                      !reportSnapshot.hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final users =
                      userSnapshot.data!.docs;

                  final requests =
                      requestSnapshot.data!.docs;

                  final reports =
                      reportSnapshot.data!.docs;

                  int aktif = 0;

                  for (var r in requests) {
                    if (r["status"] == "Aktif") {
                      aktif++;
                    }
                  }

                  return SingleChildScrollView(

                    padding:
                        const EdgeInsets.all(20),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Ringkasan Statistik",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [

                            statCard(
                              title: "Total User",
                              value:
                                  users.length.toString(),
                              icon: Icons.people,
                              color: Colors.blue,
                            ),

                            statCard(
                              title:
                                  "Permintaan\nAktif",
                              value: aktif.toString(),
                              icon:
                                  Icons.assignment,
                              color:
                                  AppColors.primary,
                            ),

                            statCard(
                              title:
                                  "Laporan\nMasuk",
                              value:
                                  reports.length.toString(),
                              icon:
                                  Icons.report_problem,
                              color: Colors.red,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Row(

                          children: [

                            Expanded(

                              child:
                                  ElevatedButton.icon(

                                icon: const Icon(
                                  Icons.category,
                                  color:
                                      Colors.white,
                                ),

                                label: const Text(
                                  "Kelola Kategori",
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors
                                          .primary,
                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),

                                onPressed: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CategoryScreen(),
                                    ),
                                  );

                                },

                              ),

                            ),

                            const SizedBox(width: 15),

                            Expanded(

                              child:
                                  ElevatedButton.icon(

                                icon: const Icon(
                                  Icons.campaign,
                                  color:
                                      Colors.white,
                                ),

                                label: const Text(
                                  "Kirim Pengumuman",
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green,
                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),

                                onPressed: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CreateAnnouncementScreen(),
                                    ),
                                  );

                                },

                              ),

                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "Aktivitas Terbaru",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 15),

                        ListView.builder(

                          shrinkWrap: true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount: requests.length > 5
                              ? 5
                              : requests.length,

                          itemBuilder:
                              (context, index) {

                            return activityCard(
                              requests[index],
                            );

                          },

                        )
                      ],
                    ),
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