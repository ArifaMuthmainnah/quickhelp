import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() =>
      _AccountSettingScreenState();
}

class _AccountSettingScreenState
    extends State<AccountSettingScreen> {
  bool visible = true;

  @override
  void initState() {
    super.initState();
    loadVisibility();
  }

  Future<void> loadVisibility() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        visible = doc["profileVisible"] ?? true;
      });
    }
  }

  Future<void> updateVisibility(bool value) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "profileVisible": value,
    });

    setState(() {
      visible = value;
    });
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .delete();

    await user.delete();

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Akun"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Preferensi Aplikasi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const ListTile(
            title: Text("Bahasa"),
            subtitle: Text("Bahasa Indonesia"),
          ),

          const ListTile(
            title: Text("Tema Aplikasi"),
            subtitle: Text("Light Mode"),
          ),

          const Divider(),

          const Text(
            "Privasi & Data",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          SwitchListTile(
            value: visible,
            onChanged: updateVisibility,
            title: const Text("Visibilitas Profil"),
            subtitle: const Text(
              "Izinkan orang lain melihat profil Anda",
            ),
          ),

          const ListTile(
            title: Text("Manajemen Data"),
            subtitle: Text(
              "Kelola cache dan unduhan",
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: deleteAccount,
            child: const Text(
              "Hapus Akun",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Menghapus akun akan menghilangkan semua data kontribusi Anda secara permanen.",
          ),
        ],
      ),
    );
  }
}