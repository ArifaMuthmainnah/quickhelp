import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'admin_user_detail_screen.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() =>
      _AdminUserScreenState();
}

class _AdminUserScreenState
    extends State<AdminUserScreen> {
  final searchController =
      TextEditingController();

  Future<void> deleteUser(
    String uid,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .delete();
  }

  Future<void> disableUser(
    String uid,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "accountStatus": "Nonaktif",
    });
  }

  Future<void> confirmDelete(
    String uid,
  ) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Hapus Pengguna",
        ),
        content: const Text(
          "Yakin ingin menghapus pengguna ini?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await deleteUser(uid);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
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
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
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

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Kelola Pengguna",
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs;

          final filteredUsers =
              users.where((doc) {
            final data =
                doc.data()
                    as Map<String, dynamic>;

            final keyword =
                searchController.text
                    .toLowerCase();

            final name =
                (data["name"] ?? "")
                    .toString()
                    .toLowerCase();

            final npm =
                (data["npm"] ?? "")
                    .toString()
                    .toLowerCase();

            return name.contains(keyword) ||
                npm.contains(keyword);
          }).toList();

          return ListView(
            padding:
                const EdgeInsets.all(20),
            children: [
              TextField(
                controller:
                    searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration:
                    InputDecoration(
                  hintText:
                      "Cari nama / NPM",
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
                            18),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              statCard(
                "Total Pengguna",
                users.length.toString(),
              ),

              const SizedBox(height: 25),

              if (filteredUsers.isEmpty)
                const Center(
                  child: Text(
                    "Tidak ada pengguna.",
                  ),
                ),

              ...filteredUsers.map((user) {
                final data =
                    user.data()
                        as Map<String, dynamic>;

                final status =
                    data["accountStatus"] ??
                        "Aktif";

                return Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 18,
                  ),
                  padding:
                      const EdgeInsets.all(
                          18),
                  decoration:
                      BoxDecoration(
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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                data["photoUrl"] !=
                                            null &&
                                        data["photoUrl"] !=
                                            ""
                                    ? NetworkImage(
                                        data["photoUrl"],
                                      )
                                    : null,
                            child: (data[
                                            "photoUrl"] ==
                                        null ||
                                    data["photoUrl"] ==
                                        "")
                                ? const Icon(
                                    Icons.person,
                                  )
                                : null,
                          ),

                          const SizedBox(
                              width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  data["name"] ??
                                      "-",
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  data["npm"] ??
                                      "-",
                                ),

                                Text(
                                  data["role"] ??
                                      "Mahasiswa",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
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
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminUserDetailScreen(
                                  uid: user.id,
                                  data: data,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Lihat Profil",
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      Row(
                        children: [
                          Expanded(
                            child:
                                ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange,
                                minimumSize:
                                    const Size(
                                        0, 50),
                              ),
                              onPressed: () {
                                disableUser(
                                    user.id);
                              },
                              child: const Text(
                                "Nonaktifkan",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 10),

                          Expanded(
                            child:
                                ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red,
                                minimumSize:
                                    const Size(
                                        0, 50),
                              ),
                              onPressed: () {
                                confirmDelete(
                                  user.id,
                                );
                              },
                              child: const Text(
                                "Hapus",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}