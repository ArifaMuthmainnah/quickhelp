import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({
    super.key,
  });

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends State<NotificationSettingScreen> {
  bool all = true;
  bool bantuan = true;
  bool chat = true;
  bool update = true;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();

      setState(() {
        all = data?["notif_all"] ?? true;
        bantuan =
            data?["notif_bantuan"] ?? true;
        chat =
            data?["notif_chat"] ?? true;
        update =
            data?["notif_update"] ?? true;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> saveSettings() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "notif_all": all,
      "notif_bantuan": bantuan,
      "notif_chat": chat,
      "notif_update": update,
    });
  }

  Widget settingTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        activeColor: AppColors.primary,
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            const Text("Pengaturan Notifikasi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Notifikasi Umum",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          settingTile(
            title: "Semua Notifikasi",
            subtitle:
                "Aktifkan atau nonaktifkan semua notifikasi",
            value: all,
            onChanged: (v) {
              setState(() {
                all = v;
                bantuan = v;
                chat = v;
                update = v;
              });

              saveSettings();
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Kategori Notifikasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          settingTile(
            title:
                "Permintaan Bantuan Baru",
            subtitle:
                "Notifikasi ketika ada request baru",
            value: bantuan,
            onChanged: (v) {
              setState(() {
                bantuan = v;
              });

              saveSettings();
            },
          ),

          settingTile(
            title: "Pesan Baru",
            subtitle:
                "Notifikasi ketika ada chat masuk",
            value: chat,
            onChanged: (v) {
              setState(() {
                chat = v;
              });

              saveSettings();
            },
          ),

          settingTile(
            title: "Pembaruan Sistem",
            subtitle:
                "Notifikasi maintenance & update aplikasi",
            value: update,
            onChanged: (v) {
              setState(() {
                update = v;
              });

              saveSettings();
            },
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: const Text(
              "Beberapa notifikasi penting seperti keamanan akun tetap akan dikirim meskipun pengaturan dimatikan.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}