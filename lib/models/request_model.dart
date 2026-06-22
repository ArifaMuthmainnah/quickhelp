import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String location;
  final String reward;
  final String duration;
  final String fileUrl;
  final String createdBy;
  final Timestamp? createdAt;

  RequestModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.location = "",
    this.reward = "",
    this.duration = "",
    this.fileUrl = "",
    this.createdBy = "",
    this.createdAt,
  });

  factory RequestModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return RequestModel(
      id: id,
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      category: map["category"] ?? "",
      status: map["status"] ?? "",
      location: map["location"] ?? "",
      reward: map["reward"] ?? "",
      duration: map["duration"] ?? "",
      fileUrl: map["fileUrl"] ?? "",
      createdBy: map["createdBy"] ?? "",
      createdAt: map["createdAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "category": category,
      "status": status,
      "location": location,
      "reward": reward,
      "duration": duration,
      "fileUrl": fileUrl,
      "createdBy": createdBy,
      "createdAt": createdAt ?? Timestamp.now(),
    };
  }
}