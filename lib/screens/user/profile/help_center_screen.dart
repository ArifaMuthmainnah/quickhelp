import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() =>
      _HelpCenterScreenState();
}

class _HelpCenterScreenState
    extends State<HelpCenterScreen> {
  final searchController =
      TextEditingController();

  final faqs = [
    {
      "q":
          "Bagaimana cara membuat permintaan bantuan?",
      "a":
          "Isi judul, deskripsi, kategori, lokasi, lalu kirim permintaan bantuan."
    },
    {
      "q":
          "Bagaimana cara membantu pengguna lain?",
      "a":
          "Pilih permintaan bantuan lalu klik Bantu Sekarang."
    },
    {
      "q":
          "Bagaimana cara mengubah status bantuan menjadi selesai?",
      "a":
          "Buka detail permintaan lalu klik Tandai Selesai."
    },
    {
      "q":
          "Kenapa saya tidak bisa login?",
      "a":
          "Pastikan NPM dan password benar."
    },
    {
      "q":
          "Bagaimana cara menggunakan fitur chat?",
      "a":
          "Klik tombol Chat pada halaman detail bantuan."
    },
    {
      "q":
          "Apakah saya bisa menghubungi lewat WhatsApp?",
      "a":
          "Ya, gunakan tombol WhatsApp di halaman chat."
    },
    {
      "q":
          "Bagaimana jika bantuan tidak dikembalikan?",
      "a":
          "Laporkan pengguna lewat tombol Laporkan."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Cari bantuan...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Kategori FAQ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...faqs
              .where((faq) => faq["q"]!
                  .toLowerCase()
                  .contains(searchController.text
                      .toLowerCase()))
              .map(
                (faq) => ExpansionTile(
                  title: Text(faq["q"]!),
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Text(faq["a"]!),
                    ),
                  ],
                ),
              ),

          const SizedBox(height: 30),

          const Text(
            "Masih butuh bantuan?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("Live Chat"),
          ),

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email Kami"),
          ),
        ],
      ),
    );
  }
}