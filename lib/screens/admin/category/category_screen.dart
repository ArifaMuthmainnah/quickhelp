import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'create_category_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryRef =
        FirebaseFirestore.instance.collection("categories");

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Kelola Kategori Bantuan",
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
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
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return Column(
            children: [

              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
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
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Total Kategori",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          Text(
                            docs.length.toString(),
                            style: const TextStyle(
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
                    final data = docs[index];

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
                                          .withValues(alpha: 0.15),
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
                                        .withValues(alpha: 0.15),
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
                                    onPressed:
                                        () {},
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
                                          Colors
                                              .red,
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
                                            data.id,
                                          )
                                          .delete();
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