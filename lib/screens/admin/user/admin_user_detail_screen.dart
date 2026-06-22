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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar: AppBar(
        title:
            const Text("Detail Pengguna"),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                data["photoUrl"] != ""
                    ? NetworkImage(
                        data["photoUrl"])
                    : null,
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              data["name"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          _tile("Email", data["email"]),
          _tile("NPM", data["npm"]),
          _tile("WhatsApp",
              data["whatsapp"] ?? "-"),
          _tile("Bio",
              data["bio"] ?? "-"),
          _tile(
            "Status",
            data["accountStatus"] ??
                "Aktif",
          ),
        ],
      ),
    );
  }

  Widget _tile(
      String title,
      String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}