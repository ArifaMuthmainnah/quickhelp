import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/request_service.dart';
import '../../../theme/app_colors.dart';
import 'request_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestListScreen extends StatelessWidget {
  final String search;
  final String category;

  const RequestListScreen({
    super.key,
    required this.search,
    required this.category,
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

  @override
  Widget build(BuildContext context) {
    final service = RequestService();

    return StreamBuilder<QuerySnapshot>(
      stream: service.getRequests(
        search: search,
        category: category,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            child: const Text(
              "Belum ada permintaan bantuan.",
            ),
          );
        }

        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final matchSearch =
              search.isEmpty ||
              data["title"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase());

          final matchCategory =
              category == "Semua" ||
              data["category"] == category;

          final notMyRequest =
              data["uid"] !=
              FirebaseAuth.instance.currentUser!.uid;

          return matchSearch &&
              matchCategory &&
              notMyRequest;
        }).toList();

        return ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index];

            return Container(
              margin:
                  const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                          data["category"],
                          style: TextStyle(
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
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor(
                                  data["status"])
                              .withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Text(
                          data["status"],
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
                    data["title"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    data["description"],
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          data["location"] ??
                              "-",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      const Icon(
                        Icons.card_giftcard,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        data["reward"] ?? "-",
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,
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
                                ...(data.data() as Map<String, dynamic>),
                              }
                            ),

                          ),

                        );

                      },

                      child: const Text(
                        "Lihat Detail",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
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
    );
  }
}