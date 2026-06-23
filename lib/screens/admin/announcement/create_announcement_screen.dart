import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreateAnnouncementScreen
    extends StatefulWidget {
  const CreateAnnouncementScreen({
    super.key,
  });

  @override
  State<CreateAnnouncementScreen>
      createState() =>
          _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState
    extends State<
        CreateAnnouncementScreen> {
  final titleController =
      TextEditingController();

  final messageController =
      TextEditingController();

  String target = "Semua User";

  Future<void> kirimPengumuman() async {
    if (titleController.text
            .trim()
            .isEmpty ||
        messageController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Judul dan isi pengumuman wajib diisi",
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child:
            CircularProgressIndicator(),
      ),
    );

    await FirebaseFirestore.instance
        .collection("announcements")
        .add({
      "title":
          titleController.text.trim(),
      "message": messageController.text
          .trim(),
      "target": target,
      "createdAt": Timestamp.now(),
    });

    if (!mounted) return;

    Navigator.pop(context);

    titleController.clear();
    messageController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),
        title: const Text(
          "Berhasil",
        ),
        content: const Text(
          "Pengumuman berhasil dikirim.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget templateButton(
    String title,
    String message,
  ) {
    return OutlinedButton(
      onPressed: () {
        titleController.text = title;
        messageController.text =
            message;
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Buat Pengumuman",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Judul Pengumuman",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            CustomTextField(
              controller:
                  titleController,
              hint:
                  "Contoh: Maintenance Terjadwal",
            ),

            const SizedBox(height: 20),

            const Text(
              "Target Penerima",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField(
              initialValue: target,
              decoration:
                  InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              16),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Semua User",
                  child: Text(
                    "Semua User",
                  ),
                ),
                DropdownMenuItem(
                  value: "User Aktif",
                  child: Text(
                    "User Aktif",
                  ),
                ),
                DropdownMenuItem(
                  value: "User Baru",
                  child: Text(
                    "User Baru",
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  target = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Isi Pesan",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            CustomTextField(
              controller:
                  messageController,
              hint:
                  "Tulis isi pengumuman...",
              maxLines: 6,
            ),

            const SizedBox(height: 25),

            const Text(
              "Template Cepat",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                templateButton(
                  "Maintenance",
                  "Sistem akan menjalani maintenance mulai pukul 22.00 WIB.",
                ),
                templateButton(
                  "Update Aplikasi",
                  "QuickHelp telah diperbarui ke versi terbaru.",
                ),
                templateButton(
                  "Pengumuman",
                  "Harap selalu menjaga etika selama menggunakan QuickHelp.",
                ),
              ],
            ),

            const SizedBox(height: 35),

            CustomButton(
              text:
                  "Kirim Pengumuman",
              onTap:
                  kirimPengumuman,
            ),

            const SizedBox(height: 35),

            const Text(
              "Pengumuman Terbaru",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder<
                QuerySnapshot>(
              stream:
                  FirebaseFirestore
                      .instance
                      .collection(
                          "announcements")
                      .orderBy(
                        "createdAt",
                        descending: true,
                      )
                      .limit(5)
                      .snapshots(),
              builder: (context,
                  snapshot) {
                if (!snapshot
                    .hasData) {
                  return const SizedBox();
                }

                final docs =
                    snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      docs.length,
                  itemBuilder:
                      (_, index) {
                    final data =
                        docs[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                      child: ListTile(
                        leading:
                            const CircleAvatar(
                          backgroundColor:
                              AppColors
                                  .primary,
                          child: Icon(
                            Icons.campaign,
                            color: Colors
                                .white,
                          ),
                        ),
                        title: Text(
                          data["title"],
                        ),
                        subtitle: Text(
                          data["target"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}