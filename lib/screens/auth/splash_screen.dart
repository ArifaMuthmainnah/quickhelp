import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scale = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    controller.forward();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.primary,

      body: Center(

        child: ScaleTransition(

          scale: scale,

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Hero(

                tag: "logo",

                child: Container(

                  width: 170,

                  height: 170,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(38),

                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(18),

                    child: Image.asset(

                      "assets/images/LogoSplashScreen.png",

                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(

                "QuickHelp",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 36,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 8),

              const Text(

                "Helping Students Faster",

                style: TextStyle(

                  color: Colors.white70,

                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}