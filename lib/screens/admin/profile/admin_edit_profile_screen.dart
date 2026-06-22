import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/cloudinary_service.dart';
import '../../../theme/app_colors.dart';

class AdminEditProfileScreen extends StatefulWidget {
  const AdminEditProfileScreen({super.key});

  @override
  State<AdminEditProfileScreen> createState() =>
      _AdminEditProfileScreenState();
}

class _AdminEditProfileScreenState
    extends State<AdminEditProfileScreen> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();

  final cloudinary = CloudinaryService();

  bool loading = false;

  File? selectedImage;
  String imageUrl = "";

  Future<void> pickImage() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedImage =
            File(result.files.single.path!);
      });
    }
  }

  Future<void> loadData() async {
    final user =
        FirebaseAuth.instance.currentUser!;

    final doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    if (doc.exists) {
      nameController.text =
          doc["name"] ?? "";

      bioController.text =
          doc["bio"] ?? "";

      imageUrl =
          doc["photoUrl"] ?? "";

      setState(() {});
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      loading = true;
    });

    final user =
        FirebaseAuth.instance.currentUser!;

    String finalPhoto = imageUrl;

    if (selectedImage != null) {
      final uploaded =
          await cloudinary.uploadFile(
        selectedImage!,
      );

      if (uploaded != null) {
        finalPhoto = uploaded;
      }
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "name": nameController.text,
      "bio": bioController.text,
      "photoUrl": finalPhoto,
    });

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Profil berhasil diperbarui"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Edit Profil"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor:
                    AppColors.primary,

                backgroundImage:
                    selectedImage != null
                        ? FileImage(
                            selectedImage!,
                          )
                        : imageUrl.isNotEmpty
                            ? NetworkImage(
                                imageUrl,
                              )
                            : null,

                child: selectedImage == null &&
                        imageUrl.isEmpty
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 35,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama Admin",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: FirebaseAuth
                        .instance
                        .currentUser
                        ?.email ??
                    "-",
                filled: true,
                fillColor:
                    Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: bioController,
              maxLines: 4,
              maxLength: 150,
              decoration: InputDecoration(
                labelText: "Bio Singkat",
                hintText:
                    "Tulis bio singkat...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                ),
                onPressed:
                    loading ? null : saveProfile,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}