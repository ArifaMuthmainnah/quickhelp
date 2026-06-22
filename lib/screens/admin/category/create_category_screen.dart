import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() =>
      _CreateCategoryScreenState();
}

class _CreateCategoryScreenState
    extends State<CreateCategoryScreen> {

  final nama = TextEditingController();
  final deskripsi =
      TextEditingController();

  Future simpan() async {

    await FirebaseFirestore.instance
        .collection("categories")
        .add({

      "name": nama.text,

      "description": deskripsi.text,

      "createdAt": Timestamp.now(),

    });

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Tambah Kategori",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            CustomTextField(
              controller: nama,
              hint: "Nama kategori",
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: deskripsi,
              hint: "Deskripsi",
              maxLines: 4,
            ),

            const SizedBox(height: 35),

            CustomButton(
              text: "Simpan",
              onTap: simpan,
            )

          ],
        ),
      ),
    );
  }
}