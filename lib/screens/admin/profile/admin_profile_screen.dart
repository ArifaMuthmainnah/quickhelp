import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../auth/login_screen.dart';
import '../announcement/create_announcement_screen.dart';
import '../category/category_screen.dart';
import 'admin_edit_profile_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profil"),
        centerTitle: true,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                /// FOTO PROFIL
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.primary,
                  backgroundImage:
                      data["photoUrl"] != null &&
                              data["photoUrl"] != ""
                          ? NetworkImage(
                              data["photoUrl"],
                            )
                          : null,
                  child: data["photoUrl"] == null ||
                          data["photoUrl"] == ""
                      ? const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 50,
                        )
                      : null,
                ),

                const SizedBox(height: 18),

                Text(
                  data["name"] ?? "Administrator",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  data["email"] ??
                      FirebaseAuth.instance.currentUser?.email ??
                      "-",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Administrator",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// BIO
                profileTile(
                  Icons.info,
                  "Bio",
                  data["bio"] ?? "-",
                ),

                profileTile(
                  Icons.verified_user,
                  "Status",
                  "Aktif",
                ),

                const SizedBox(height: 20),

                /// MENU
                menuTile(
                  icon: Icons.edit,
                  title: "Edit Profil",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AdminEditProfileScreen(),
                      ),
                    );
                  },
                ),

                menuTile(
                  icon: Icons.category,
                  title: "Kelola Kategori",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CategoryScreen(),
                      ),
                    );
                  },
                ),

                menuTile(
                  icon: Icons.campaign,
                  title: "Kirim Pengumuman",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CreateAnnouncementScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Keluar",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            "Yakin ingin keluar?",
                          ),
                          content: const Text(
                            "Kamu harus login kembali untuk masuk.",
                          ),
                          actions: [

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Batal"),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                logout(context);
                              },
                              child: const Text("Keluar"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              AppColors.primary.withValues(alpha: 0.15),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(title),
        trailing:
            const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget profileTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppColors.primary.withValues(alpha: 0.15),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

class AdminCategoryScreen extends StatelessWidget {
  const AdminCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
      ),
      body: const Center(
        child: Text('Halaman Kelola Kategori'),
      ),
    );
  }
}