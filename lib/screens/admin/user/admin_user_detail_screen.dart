import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class AdminUserDetailScreen
    extends StatelessWidget {
  final String uid;
  final Map<String, dynamic> data;

  const AdminUserDetailScreen({
    super.key,
    required this.uid,
    required this.data,
  });

  Widget infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
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
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status =
        data["accountStatus"] ?? "Aktif";

    final role =
        data["role"] ?? "Mahasiswa";

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Detail Pengguna",
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(20),
        children: [
          Container(
            padding:
                const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                      22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(
                    alpha: 0.05,
                  ),
                  blurRadius: 10,
                  offset:
                      const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor:
                      AppColors.primary,
                  backgroundImage:
                      data["photoUrl"] !=
                                  null &&
                              data["photoUrl"] !=
                                  ""
                          ? NetworkImage(
                              data["photoUrl"],
                            )
                          : null,
                  child: (data["photoUrl"] ==
                              null ||
                          data["photoUrl"] ==
                              "")
                      ? const Icon(
                          Icons.person,
                          color:
                              Colors.white,
                          size: 40,
                        )
                      : null,
                ),

                const SizedBox(
                    height: 18),

                Text(
                  data["name"] ?? "-",
                  style:
                      const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 8),

                Text(
                  role,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                    height: 15),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color: status ==
                            "Nonaktif"
                        ? Colors.red
                        : Colors.green,
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Text(
                    status,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          infoTile(
            Icons.email,
            "Email",
            data["email"] ?? "-",
          ),

          infoTile(
            Icons.badge,
            "NPM",
            data["npm"] ?? "-",
          ),

          infoTile(
            Icons.phone,
            "WhatsApp",
            data["whatsapp"] ?? "-",
          ),

          infoTile(
            Icons.person_outline,
            "Bio",
            data["bio"] ?? "-",
          ),

          infoTile(
            Icons.verified_user,
            "UID",
            uid,
          ),
        ],
      ),
    );
  }
}