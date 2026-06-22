import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../services/cloudinary_service.dart';
import '../../../services/request_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState
    extends State<CreateRequestScreen> {
  final titleController =
      TextEditingController();

  final descController =
      TextEditingController();

  final rewardController =
      TextEditingController();

  final deadlineController =
      TextEditingController();

  final durationController =
      TextEditingController();

  final locationController =
      TextEditingController();

  String category = "Akademik";

  File? selectedFile;

  bool loading = false;

  final requestService =
      RequestService();

  final cloudinaryService =
      CloudinaryService();

  Future<void> pickFile() async {
    final result =
        await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile =
            File(result.files.single.path!);
      });
    }
  }

  Future<void> publishRequest() async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty ||
        locationController.text.isEmpty ||
        rewardController.text.isEmpty ||
        deadlineController.text.isEmpty ||
        durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Semua field wajib diisi."),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    String fileUrl = "";

    if (selectedFile != null) {
      final url =
          await cloudinaryService.uploadFile(
        selectedFile!,
      );

      if (url != null) {
        fileUrl = url;
      }
    }

    await requestService.addRequest(
      title: titleController.text,
      description: descController.text,
      category: category,
      reward: rewardController.text,
      deadline: deadlineController.text,
      duration: durationController.text,
      location: locationController.text,
      fileUrl: fileUrl,
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Permintaan berhasil dibuat",
        ),
        content: const Text(
          "Permintaan bantuan telah dipublikasikan.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              titleController.clear();
              descController.clear();
              rewardController.clear();
              deadlineController.clear();
              durationController.clear();
              locationController.clear();

              setState(() {
                selectedFile = null;
              });
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
         automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor:
            Colors.transparent,
        title: const Text(
          "Buat Permintaan",
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [

              sectionTitle("Judul"),

              CustomTextField(
                controller:
                    titleController,
                hint:
                    "Contoh: Pinjam kalkulator scientific",
              ),

              const SizedBox(height: 18),

              sectionTitle("Deskripsi"),

              TextField(
                controller:
                    descController,
                maxLines: 5,
                decoration:
                    InputDecoration(
                  filled: true,
                  fillColor:
                      Colors.white,
                  hintText:
                      "Contoh: Saya butuh pinjam kalkulator untuk ujian Matematika besok pagi.",
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            18),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              sectionTitle("Kategori"),

              DropdownButtonFormField(
                initialValue: category,
                decoration:
                    InputDecoration(
                  filled: true,
                  fillColor:
                      Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            18),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value:
                        "Akademik",
                    child:
                        Text("Akademik"),
                  ),
                  DropdownMenuItem(
                    value:
                        "Barang",
                    child:
                        Text("Barang"),
                  ),
                  DropdownMenuItem(
                    value:
                        "Sosial",
                    child:
                        Text("Sosial"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    category =
                        value!;
                  });
                },
              ),

              const SizedBox(height: 18),

              sectionTitle("Lokasi"),

              CustomTextField(
                controller:
                    locationController,
                hint:
                    "Contoh: Fakultas Teknik, Ruang 204",
              ),

              const SizedBox(height: 18),

              sectionTitle("Reward"),

              CustomTextField(
                controller:
                    rewardController,
                hint:
                    "Contoh: Rp20.000 / Traktir kopi",
              ),

              const SizedBox(height: 18),

              sectionTitle("Masa Berlaku"),

              CustomTextField(
                controller:
                    deadlineController,
                hint:
                    "Contoh: Sebelum Senin jam 08:00",
              ),

              const SizedBox(height: 18),

              sectionTitle("Durasi Bantuan"),

              CustomTextField(
                controller:
                    durationController,
                hint:
                    "Contoh: Dipinjam selama 3 hari",
              ),

              const SizedBox(height: 18),

              sectionTitle("Lampiran"),

              InkWell(
                onTap: pickFile,
                child: Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets
                          .all(18),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                                18),
                    border:
                        Border.all(
                      color:
                          Colors.grey
                              .shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color:
                            AppColors.primary,
                      ),
                      const SizedBox(
                          width: 12),
                      Expanded(
                        child: Text(
                          selectedFile == null
                              ? "Pilih file bukti/lampiran"
                              : selectedFile!
                                  .path
                                  .split("/")
                                  .last,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              loading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text:
                          "Publikasikan",
                      onTap:
                          publishRequest,
                    ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}