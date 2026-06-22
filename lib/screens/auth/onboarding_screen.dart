import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

import '../../widgets/custom_button.dart';

import '../landing/landing_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController controller =
      PageController();

  int current = 0;

  final pages = [

    {
      "image":"assets/images/LogoSplashScreen.png",

      "title":"QuickHelp",

      "desc":"Platform bantuan cepat antar mahasiswa dalam lingkungan kampus."
    },

    {

      "image":"assets/images/LogoSplashScreen.png",

      "title":"Minta Bantuan",

      "desc":"Kamu butuh bantuan cepat? \nPinjam barang, cari teman belajar, atau minta bantuan akademik dengan mudah."

    },

    {

      "image":"assets/images/LogoSplashScreen.png",

      "title":"Bantu Sesama",

      "desc":"Temukan permintaan mahasiswa lain dan berikan bantuan hanya dalam beberapa klik."

    }

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(28),

          child: Column(

            children: [

              Expanded(

                child: PageView.builder(

                  controller: controller,

                  itemCount: pages.length,

                  onPageChanged: (i){

                    setState(() {

                      current=i;

                    });

                  },

                  itemBuilder: (_,index){

                    final page=pages[index];

                    return Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Container(

                          width: 260,

                          height: 260,

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(30),

                            boxShadow: [

                              BoxShadow(

                                blurRadius: 20,

                                color: Colors.black.withValues(alpha: 0.08),

                              )

                            ],

                          ),

                          child: Padding(

                            padding: const EdgeInsets.all(30),

                            child: Image.asset(
                              page["image"]!,
                            ),
                          ),
                        ),

                        const SizedBox(height:50),

                        Text(

                          page["title"]!,

                          style: AppTextStyles.title,

                          textAlign: TextAlign.center,

                        ),

                        const SizedBox(height:20),

                        Text(

                          page["desc"]!,

                          style: AppTextStyles.subtitle,

                          textAlign: TextAlign.center,

                        )

                      ],
                    );

                  },

                ),

              ),

              Row(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: List.generate(

                  pages.length,

                  (index){

                    return AnimatedContainer(

                      duration:
                          const Duration(milliseconds:300),

                      margin: const EdgeInsets.symmetric(horizontal:4),

                      width: current==index?30:10,

                      height:10,

                      decoration: BoxDecoration(

                        color: current==index
                            ?AppColors.primary.withValues(alpha: 0.15)
                            :Colors.grey.shade300,

                        borderRadius:
                            BorderRadius.circular(30),

                      ),

                    );

                  },

                ),

              ),

              const SizedBox(height:35),

              CustomButton(

                text: current==2
                    ?"MULAI SEKARANG"
                    :"LANJUT",

                onTap:(){

                  if(current==2){

                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(

                        builder:(_)=>const LandingScreen(),

                      ),

                    );

                  }else{

                    controller.nextPage(

                      duration: const Duration(milliseconds:350),

                      curve: Curves.ease,

                    );

                  }

                },

              )

            ],
          ),
        ),
      ),
    );
  }
}