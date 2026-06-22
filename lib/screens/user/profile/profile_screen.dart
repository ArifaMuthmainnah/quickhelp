import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_setting_screen.dart';
import 'notification_setting_screen.dart';
import 'help_center_screen.dart';

import '../../../theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<int> getMyRequestCount(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("requests")
        .where("uid", isEqualTo: uid)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getHelpedCount(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("requests")
        .where("helperId", isEqualTo: uid)
        .get();

    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User belum login"),
        ),
      );
    }

    final uid = user.uid;

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
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text("Data user tidak ditemukan"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          return FutureBuilder(
            future: Future.wait([
              getHelpedCount(uid),
              getMyRequestCount(uid),
            ]),
            builder: (context, countSnapshot) {
              if (!countSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final helped =
                  countSnapshot.data![0];
              final myRequest =
                  countSnapshot.data![1];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.primary,
                      backgroundImage:
                          (data["photoUrl"] != null &&
                                  data["photoUrl"] != "")
                              ? NetworkImage(data["photoUrl"])
                              : null,
                      child: (data["photoUrl"] == null ||
                              data["photoUrl"] == "")
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 55,
                            )
                          : null,
                    ),

                    const SizedBox(height: 18),

                    Text(
                      data["name"] ?? "-",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      data["email"] ?? "-",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            "Total Bantuan",
                            helped.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: statCard(
                            "Permintaan Saya",
                            myRequest.toString(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Edit Profil",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    profileTile(
                      Icons.badge,
                      "NPM",
                      data["npm"] ?? "-",
                    ),

                    profileTile(
                      Icons.phone,
                      "WhatsApp",
                      data["whatsapp"] ?? "-",
                    ),

                    profileTile(
                      Icons.email,
                      "Email",
                      data["email"] ?? "-",
                    ),

                    profileTile(
                      Icons.info,
                      "Bio",
                      data["bio"] ?? "-",
                    ),

                    const SizedBox(height: 20),

                    menuButton(
                      Icons.settings,
                      "Pengaturan Akun",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AccountSettingScreen(),
                          ),
                        );
                      },
                    ),

                    menuButton(
                      Icons.notifications,
                      "Pengaturan Notifikasi",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NotificationSettingScreen(),
                          ),
                        );
                      },
                    ),

                    menuButton(
                      Icons.help_center,
                      "Pusat Bantuan",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const HelpCenterScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        onPressed: () async {
                          final confirm =
                              await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                "Yakin ingin keluar?",
                              ),
                              content: const Text(
                                "Kamu harus login kembali untuk masuk.",
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  },
                                  child:
                                      const Text("Ya"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      false,
                                    );
                                  },
                                  child:
                                      const Text("Batal"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await AuthService().logout();

                            if (!context.mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget statCard(String title, String total) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            total,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }

  Widget menuButton(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
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