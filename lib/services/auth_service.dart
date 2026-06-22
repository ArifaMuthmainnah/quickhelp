import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String adminEmail = "admin123@gmail.com";
  static const String adminPassword = "admin123";

  Future<String?> registerUser({
    required String name,
    required String npm,
    required String whatsapp,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "uid": credential.user!.uid,
        "name": name,
        "npm": npm,
        "whatsapp": whatsapp,
        "email": email,
        "role": "user",
        "photoUrl": "",
        "createdAt": Timestamp.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      final doc = await _firestore
          .collection("users")
          .doc(uid)
          .get();

      if (!doc.exists) {
        return "User tidak ditemukan di database";
      }

      final data = doc.data() as Map<String, dynamic>;

      final userRole = data["role"];

      // validasi role
      if (userRole.toLowerCase() != role.toLowerCase()) {
        return "Akses ditolak untuk role ini";
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<DocumentSnapshot?> getCurrentUser() async {
    if (_auth.currentUser == null) return null;

    return await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}