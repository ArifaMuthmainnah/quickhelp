import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../auth/login_screen.dart';
import 'admin_edit_profile_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Profil"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            const SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  children: [
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
                              size: 55,
                            )
                          : null,
                    ),

                    const SizedBox(height: 18),

                    Text(
                      data["name"] ?? "Administrator",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? "-",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 35),

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
                // ke halaman category
              },
            ),

            menuTile(
              icon: Icons.campaign,
              title: "Kirim Pengumuman",
              onTap: () {
                // ke halaman announcement
              },
            ),

            menuTile(
              icon: Icons.logout,
              title: "Keluar",
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      "Yakin ingin keluar?",
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

          ],
        ),
      ),
    );
  }
}