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
      "accountStatus": "Nonaktif"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Kelola Pengguna",
        ),
      ),
      body: StreamBuilder(
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

          final filteredUsers = users.where(
            (doc) {
              final data = doc.data();
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

              return name.contains(
                      keyword) ||
                  npm.contains(keyword);
            },
          ).toList();

          final totalUsers =
              users.length;

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
                      "Cari nama / npm",
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
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      "Total Pengguna",
                      totalUsers.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              ...filteredUsers.map(
                (user) {
                  final data = user.data();

                  return Card(
                    margin:
                        const EdgeInsets.only(
                            bottom: 20),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                              16),
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
                                            data["photoUrl"])
                                        : null,
                                child:
                                    data["photoUrl"] ==
                                            ""
                                        ? const Icon(
                                            Icons
                                                .person)
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
                                      data["name"],
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    Text(
                                      data["npm"],
                                    ),
                                    Text(
                                      data["bio"] ??
                                          "-",
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
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: (data["accountStatus"] ??
                                              "Aktif") ==
                                          "Nonaktif"
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Text(
                                  data["accountStatus"] ??
                                      "Aktif",
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
                              height: 20),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AdminUserDetailScreen(
                                          uid:
                                              user.id,
                                          data:
                                              data,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                      "Lihat Profil"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 10),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed: () {
                                    disableUser(
                                        user.id);
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.orange,
                                  ),
                                  child: const Text(
                                      "Nonaktifkan"),
                                ),
                              ),
                              const SizedBox(
                                  width: 10),
                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed: () {
                                    deleteUser(
                                        user.id);
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                  child: const Text(
                                      "Hapus"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(
      String title,
      String value) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}