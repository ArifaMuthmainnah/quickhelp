import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/cloudinary_service.dart';
import '../../../services/report_service.dart';
import '../../../theme/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final String reportedId;
  final String reportedName;
  final String requestId;
  final String requestTitle;

  const ReportScreen({
    super.key,
    required this.reportedId,
    required this.reportedName,
    required this.requestId,
    required this.requestTitle,
  });

  @override
  State<ReportScreen> createState() =>
      _ReportScreenState();
}

class _ReportScreenState
    extends State<ReportScreen> {
  final reportService = ReportService();

  final cloudinary =
      CloudinaryService();

  final detailController =
      TextEditingController();

  bool loading = false;

  String selectedReason = "";

  List<File> proofs = [];

  final reasons = [
    "Barang tidak dikembalikan",
    "Perilaku tidak sopan",
    "Penipuan",
    "Spam",
    "Lainnya",
  ];

  Future<void> pickImages() async {
    final result =
        await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        proofs = result.paths
            .whereType<String>()
            .map((e) => File(e))
            .toList();
      });
    }
  }

  Future<void> submitReport() async {
    if (selectedReason.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Pilih alasan laporan"),
        ),
      );
      return;
    }

    if (detailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Isi kronologi kejadian"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final user =
        FirebaseAuth.instance.currentUser!;

    List<String> urls = [];

    for (File file in proofs) {
      final url =
          await cloudinary.uploadFile(file);

      if (url != null) {
        urls.add(url);
      }
    }

    final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    await reportService.submitReport(
      reporterId: user.uid,
      reporterName: userDoc["name"],
      reportedId: widget.reportedId,
      reportedName: widget.reportedName,
      requestId: widget.requestId,
      requestTitle: widget.requestTitle,
      reason: selectedReason,
      description: detailController.text,
      evidences: urls,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Laporan berhasil dikirim"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title:
            const Text("Laporkan Pengguna"),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(20),

        children: [

          Text(
            widget.reportedName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            widget.requestTitle,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Pilih Alasan",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...reasons.map(
            (e) => RadioListTile<String>(
              value: e,
              groupValue:
                  selectedReason,
              title: Text(e),
              onChanged: (value) {
                setState(() {
                  selectedReason =
                      value!;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Kronologi",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller:
                detailController,
            maxLines: 6,
            maxLength: 500,
            decoration:
                InputDecoration(
              hintText:
                  "Jelaskan kronologi kejadian...",
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
              ),
              onPressed:
                  pickImages,
              icon: const Icon(
                Icons.photo,
                color: Colors.white,
              ),
              label: const Text(
                "Tambah Bukti",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          if (proofs.isNotEmpty)

            SizedBox(
              height: 95,

              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal,

                itemCount:
                    proofs.length,

                itemBuilder:
                    (_, index) {
                  return Stack(
                    children: [

                      Container(
                        margin:
                            const EdgeInsets.only(
                                right: 10),

                        child:
                            ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                  12),

                          child:
                              Image.file(
                            proofs[index],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        child:
                            GestureDetector(
                          onTap: () {
                            setState(() {
                              proofs.removeAt(
                                  index);
                            });
                          },
                          child:
                              const CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),

          const SizedBox(height: 35),

          SizedBox(
            height: 55,

            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
              ),

              onPressed: loading
                  ? null
                  : submitReport,

              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                          CircularProgressIndicator(
                        color:
                            Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Kirim Laporan",
                      style: TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}