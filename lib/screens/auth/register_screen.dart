import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController npmController =
      TextEditingController();

  final TextEditingController waController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final AuthService authService =
      AuthService();

  bool loading = false;

  Future<void> register() async {

    if (nameController.text.trim().isEmpty ||
        npmController.text.trim().isEmpty ||
        waController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Semua data wajib diisi."),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    String? result =
        await authService.registerUser(
      name: nameController.text.trim(),
      npm: npmController.text.trim(),
      whatsapp: waController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    setState(() {
      loading = false;
    });

    if (result == null) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            "Registrasi Berhasil",
          ),
          content: const Text(
            "Akun berhasil dibuat.\nSilakan login.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Login",
              ),
            )
          ],
        ),
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  Widget title() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          "Buat Akun",
          style: AppTextStyles.title,
        ),

        const SizedBox(height: 8),

        Text(
          "Daftar sebagai mahasiswa agar dapat meminta dan memberikan bantuan.",
          style: AppTextStyles.subtitle,
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Align(

                alignment:
                    Alignment.topLeft,

                child: Image.asset(

                  "assets/images/Logo_QuickHelp.png",

                  width: 65,

                ),

              ),

              const SizedBox(height: 20),

              title(),

              const SizedBox(height: 35),

              CustomTextField(
                controller: nameController,
                hint: "Nama Lengkap",
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: npmController,
                hint: "NPM",
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: waController,
                hint: "Nomor WhatsApp",
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: emailController,
                hint: "Email",
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller:
                    passwordController,
                hint: "Password",
                obscure: true,
              ),

              const SizedBox(height: 35),

              loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : CustomButton(
                      text: "DAFTAR",
                      onTap: register,
                    ),

              const SizedBox(height: 18),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Sudah punya akun? Masuk",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}