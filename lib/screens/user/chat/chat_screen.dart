import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String whatsapp;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userName,
    this.whatsapp = "",
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {
  final controller =
      TextEditingController();

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final currentUser =
        FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .set({
      "userName": widget.userName,
      "whatsapp": widget.whatsapp,
      "lastMessage": controller.text.trim(),
      "updatedAt": Timestamp.now(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .add({
      "message": controller.text.trim(),
      "senderId": currentUser.uid,
      "createdAt": Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection("notifications")
        .add({
      "uid": widget.chatId.split("_").last,
      "title": "Pesan Baru",
      "description":
          "${currentUser.email} mengirim pesan",
      "createdAt": Timestamp.now(),
    });

    controller.clear();
  }

  Future<void> openWhatsApp() async {
    if (widget.whatsapp.trim().isEmpty) return;

    String phone = widget.whatsapp.trim();

    // hapus semua selain angka
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // konversi 0xxx → 62xxx
    if (phone.startsWith("0")) {
      phone = "62${phone.substring(1)}";
    }

    final Uri url = Uri.parse("https://wa.me/$phone");

    print("WA URL: $url");

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp gagal dibuka"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.userName),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: Colors.green,
            ),
            onPressed: openWhatsApp,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("createdAt")
                  .snapshots(),
              builder:
                  (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final docs =
                    snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pesan",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets
                          .all(20),
                  itemCount: docs.length,
                  itemBuilder:
                      (_, index) {
                    final data =
                        docs[index];

                    final isMe =
                        data["senderId"] ==
                            currentUid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 12,
                        ),
                        padding:
                            const EdgeInsets
                                .all(15),
                        constraints:
                            const BoxConstraints(
                          maxWidth: 260,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),
                        child: Text(
                          (data["message"] ?? "")
                              .toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        controller,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Tulis pesan...",
                      filled: true,
                      fillColor:
                          Colors.white,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}