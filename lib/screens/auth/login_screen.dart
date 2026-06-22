import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../user/dashboard/user_dashboard.dart';
import '../admin/dashboard/admin_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final AuthService authService = AuthService();

  String selectedRole = "user";

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Semua data wajib diisi."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? result =
        await authService.loginUser(
      email: emailController.text.trim(),
      password:
          passwordController.text.trim(),
      role:
          selectedRole == "admin"
              ? "admin"
              : "user",
    );

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      if (selectedRole == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AdminDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const UserDashboard(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  Widget buildLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset(
        "assets/images/Logo_QuickHelp.png",
        width: 65,
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat Datang 👋",
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 8),
        Text(
          "Masuk ke akun QuickHelp untuk mulai meminta ataupun memberikan bantuan.",
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }

  Widget buildRoleDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: selectedRole,
        isExpanded: true,
        borderRadius:
            BorderRadius.circular(16),
        decoration:
            const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.badge_outlined,
          ),
          labelText: "Masuk Sebagai",
          contentPadding:
              EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: "user",
            child: Text("Mahasiswa"),
          ),
          DropdownMenuItem(
            value: "admin",
            child: Text("Admin"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedRole = value!;
          });
        },
      ),
    );
  }

  Widget buildBottomText() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        const Text(
          "Belum punya akun?",
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const RegisterScreen(),
              ),
            );
          },
          child: const Text(
            "Daftar",
          ),
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

              buildLogo(),

              const SizedBox(height: 25),

              buildTitle(),

              const SizedBox(height: 35),

              CustomTextField(
                controller:
                    emailController,
                hint: "Email",
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: passwordController,
                hint: "Password",
                obscure: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 18),

              buildRoleDropdown(),

              const SizedBox(height: 35),

              isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : CustomButton(
                      text: "MASUK",
                      onTap: login,
                    ),

              const SizedBox(height: 20),

              buildBottomText(),
            ],
          ),
        ),
      ),
    );
  }
}