import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dywpflzzp";

  static const String uploadPreset =
      "quickhelp_upload";

  Future<String?> uploadFile(File file) async {
    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
      );

      final request =
          http.MultipartRequest("POST", uri);

      request.fields["upload_preset"] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
        ),
      );

      final response =
          await request.send();

      if (response.statusCode == 200) {
        final body =
            await response.stream.bytesToString();

        final data =
            jsonDecode(body);

        return data["secure_url"];
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}