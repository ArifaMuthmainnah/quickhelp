import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

import '../notifications/notification_screen.dart';
import '../request/request_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController searchController =
      TextEditingController();

  String search = "";

  String category = "Semua";

  Stream<DocumentSnapshot<Map<String, dynamic>>> 
    getUser() {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      return FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .snapshots();
    }

  Widget categoryButton(String text) {

    final selected = category == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          category = text;

        });

      },

      child: AnimatedContainer(

        duration:
            const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        decoration: BoxDecoration(

          color: selected
              ? AppColors.primary
              : Colors.white,

          borderRadius:
              BorderRadius.circular(30),

          border: Border.all(
            color: AppColors.primary,
          ),

        ),

        child: Text(

          text,

          style: TextStyle(

            color: selected
                ? Colors.white
                : AppColors.primary,

            fontWeight: FontWeight.w600,

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

      body: SafeArea(

        child: StreamBuilder(

          stream: getUser(),

          builder: (context, snapshot) {

            if (!snapshot.hasData) {

              return const Center(
                child:
                    CircularProgressIndicator(),
              );

            }

            final user = snapshot.data!.data()!;

            return RefreshIndicator(

              onRefresh: () async {

                setState(() {});

              },

              child: ListView(

                padding:
                    const EdgeInsets.all(20),

                children: [

                  Row(

                    children: [

                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        backgroundImage:
                            (user["photoUrl"] != null &&
                                    user["photoUrl"] != "")
                                ? NetworkImage(user["photoUrl"])
                                : null,
                        child: (user["photoUrl"] == null ||
                                user["photoUrl"] == "")
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(width: 14),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              "Halo 👋",

                              style: AppTextStyles
                                  .subtitle,

                            ),

                            Text(

                              user["name"],

                              style: AppTextStyles
                                  .title,

                            ),

                          ],

                        ),

                      ),

                      IconButton(

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const NotificationScreen(),

                            ),

                          );

                        },

                        icon: const Icon(

                          Icons
                              .notifications_none_rounded,

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(height: 30),

                  TextField(

                    controller: searchController,

                    onChanged: (value) {

                      setState(() {

                        search = value;

                      });

                    },

                    decoration: InputDecoration(

                      hintText:
                          "Cari bantuan...",

                      prefixIcon:
                          const Icon(Icons.search),

                      filled: true,

                      fillColor: Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                                18),

                        borderSide:
                            BorderSide.none,

                      ),

                    ),

                  ),

                  const SizedBox(height: 25),

                  Text(

                    "Kategori",

                    style: AppTextStyles.title
                        .copyWith(fontSize: 20),

                  ),

                  const SizedBox(height: 15),

                  SingleChildScrollView(

                    scrollDirection:
                        Axis.horizontal,

                    child: Row(

                      children: [

                        categoryButton("Semua"),

                        const SizedBox(width: 12),

                        categoryButton("Akademik"),

                        const SizedBox(width: 12),

                        categoryButton("Barang"),

                        const SizedBox(width: 12),

                        categoryButton("Sosial"),

                      ],

                    ),

                  ),

                  const SizedBox(height: 30),

                  Text(

                    "Permintaan Bantuan",

                    style: AppTextStyles.title
                        .copyWith(fontSize: 20),

                  ),

                  const SizedBox(height: 15),

                  RequestListScreen(

                    search: search,

                    category: category,

                  ),

                ],

              ),

            );

          },

        ),

      ),

    );

  }

}