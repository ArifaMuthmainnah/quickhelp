import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'create_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState
    extends State<CategoryScreen> {
  final categoryRef =
      FirebaseFirestore.instance.collection(
    "categories",
  );

  Future<void> seedDefaultCategories() async {
    final snapshot = await categoryRef.get();

    if (snapshot.docs.isEmpty) {
      final defaults = [
        {
          "name": "Akademik",
          "description":
              "Bantuan terkait tugas, belajar, dan kuliah",
        },
        {
          "name": "Barang",
          "description":
              "Bantuan pinjam, cari, atau antar barang",
        },
        {
          "name": "Sosial",
          "description":
              "Bantuan sosial dan kegiatan masyarakat",
        },
      ];

      for (var item in defaults) {
        await categoryRef.add(item);
      }
    }
  }

  Future<void> editCategory(
    String id,
    String oldName,
    String oldDesc,
  ) async {
    final nameController =
        TextEditingController(text: oldName);

    final descController =
        TextEditingController(text: oldDesc);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Kategori"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await categoryRef.doc(id).update({
                "name":
                    nameController.text.trim(),
                "description":
                    descController.text.trim(),
              });

              if (!mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Kategori berhasil diupdate",
                  ),
                ),
              );
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    seedDefaultCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Kelola Kategori Bantuan",
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateCategoryScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Tambah",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: categoryRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.all(20),
                padding:
                    const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor:
                          AppColors.primary,
                      child: Icon(
                        Icons.category,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            "Total Kategori",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            docs.length.toString(),
                            style:
                                const TextStyle(
                              fontSize: 26,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (_, index) {
                    final data =
                        docs[index].data()
                            as Map<String,
                                dynamic>;

                    return Card(
                      margin:
                          const EdgeInsets.only(
                              bottom: 15),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                18),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      AppColors
                                          .primary
                                          .withValues(
                                              alpha:
                                                  0.15),
                                  child: const Icon(
                                    Icons.category,
                                    color:
                                        AppColors
                                            .primary,
                                  ),
                                ),

                                const SizedBox(
                                    width: 15),

                                Expanded(
                                  child: Text(
                                    data["name"],
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        12,
                                    vertical: 5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .green
                                        .withValues(
                                            alpha:
                                                0.15),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),
                                  child:
                                      const Text(
                                    "Aktif",
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                                height: 15),

                            Text(
                              data["description"],
                            ),

                            const SizedBox(
                                height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                      OutlinedButton.icon(
                                    icon:
                                        const Icon(
                                      Icons.edit,
                                    ),
                                    label:
                                        const Text(
                                      "Edit",
                                    ),
                                    onPressed: () {
                                      editCategory(
                                        docs[index]
                                            .id,
                                        data["name"],
                                        data[
                                            "description"],
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                    width: 10),

                                Expanded(
                                  child:
                                      ElevatedButton.icon(
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                    icon:
                                        const Icon(
                                      Icons.delete,
                                      color: Colors
                                          .white,
                                    ),
                                    label:
                                        const Text(
                                      "Hapus",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                    onPressed:
                                        () async {
                                      await categoryRef
                                          .doc(
                                            docs[index]
                                                .id,
                                          )
                                          .delete();

                                      if (!mounted)
                                        return;

                                      ScaffoldMessenger
                                              .of(
                                                  context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Kategori berhasil dihapus",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}