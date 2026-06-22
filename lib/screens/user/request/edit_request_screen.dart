import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class EditRequestScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditRequestScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditRequestScreen> createState() =>
      _EditRequestScreenState();
}

class _EditRequestScreenState
    extends State<EditRequestScreen> {
  late TextEditingController titleController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController deadlineController;
  late TextEditingController durationController;
  late TextEditingController rewardController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.data["title"],
    );

    categoryController = TextEditingController(
      text: widget.data["category"],
    );

    descriptionController =
        TextEditingController(
      text: widget.data["description"],
    );

    locationController = TextEditingController(
      text: widget.data["location"],
    );

    deadlineController = TextEditingController(
      text: widget.data["deadline"],
    );

    durationController = TextEditingController(
      text: widget.data["duration"],
    );

    rewardController = TextEditingController(
      text: widget.data["reward"],
    );
  }

  Future<void> updateRequest() async {
    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance
        .collection("requests")
        .doc(widget.data["docId"])
        .update({
      "title": titleController.text,
      "category": categoryController.text,
      "description":
          descriptionController.text,
      "location": locationController.text,
      "deadline": deadlineController.text,
      "duration": durationController.text,
      "reward": rewardController.text,
    });

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Permintaan berhasil diupdate"),
      ),
    );

    Navigator.pop(context);
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    deadlineController.dispose();
    durationController.dispose();
    rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Edit Permintaan",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            inputField(
              label: "Judul",
              controller: titleController,
            ),
            inputField(
              label: "Kategori",
              controller:
                  categoryController,
            ),
            inputField(
              label: "Deskripsi",
              controller:
                  descriptionController,
              maxLines: 4,
            ),
            inputField(
              label: "Lokasi",
              controller:
                  locationController,
            ),
            inputField(
              label: "Deadline",
              controller:
                  deadlineController,
            ),
            inputField(
              label: "Durasi",
              controller:
                  durationController,
            ),
            inputField(
              label: "Imbalan",
              controller:
                  rewardController,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                ),
                onPressed: loading
                    ? null
                    : updateRequest,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}