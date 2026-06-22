import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../services/cloudinary_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final namaController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final whatsappController =
      TextEditingController();

  final bioController =
      TextEditingController();

  bool isLoading = false;

  File? selectedImage;

  String photoUrl = "";

  final cloudinaryService =
      CloudinaryService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    final data = doc.data();

    if (data != null) {
      setState(() {
        namaController.text =
            data["name"] ?? "";

        emailController.text =
            data["email"] ?? "";

        whatsappController.text =
            data["whatsapp"] ?? "";

        bioController.text =
            data["bio"] ?? "";

        photoUrl =
            data["photoUrl"] ?? "";
      });
    }
  }

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

  Future<void> updateProfile() async {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    setState(() {
      isLoading = true;
    });

    try {
      String finalPhotoUrl = photoUrl;

      if (selectedImage != null) {
        final uploaded =
            await cloudinaryService.uploadFile(
          selectedImage!,
        );

        if (uploaded != null) {
          finalPhotoUrl = uploaded;
        }
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({
        "name": namaController.text.trim(),
        "email": emailController.text.trim(),
        "whatsapp":
            whatsappController.text.trim(),
        "bio": bioController.text.trim(),
        "photoUrl": finalPhotoUrl,
        "updatedAt": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Profil berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text("Gagal update: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

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
                        : (photoUrl.isNotEmpty
                            ? NetworkImage(
                                photoUrl,
                              )
                            : null) as ImageProvider?,
                child: selectedImage == null &&
                        photoUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 55,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap untuk ganti foto",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 35),

            CustomTextField(
              controller: namaController,
              hint: "Nama",
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: emailController,
              hint: "Email",
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller:
                  whatsappController,
              hint: "Nomor WhatsApp",
            ),

            const SizedBox(height: 18),

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Bio Singkat",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          16),
                ),
              ),
            ),

            const SizedBox(height: 35),

            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "Simpan",
                    onTap: updateProfile,
                  ),
          ],
        ),
      ),
    );
  }
}