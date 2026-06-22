import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

import '../home/home_screen.dart';
import '../help/help_screen.dart';
import '../request/create_request_screen.dart';
import '../request/history_request_screen.dart';
import '../profile/profile_screen.dart';
import '../message/message_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() =>
      _UserDashboardState();
}

class _UserDashboardState
    extends State<UserDashboard> {

  int currentIndex = 0;

  final List<Widget> pages = const [

    HomeScreen(),

    HelpScreen(),

    CreateRequestScreen(),

    HistoryRequestScreen(),

    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MessageScreen(),
            ),
          );
        },
      ),

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        elevation: 12,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(

            icon: Icon(Icons.home_rounded),

            label: "BERANDA",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.volunteer_activism_rounded),

            label: "BANTU",

          ),

          BottomNavigationBarItem(

            icon: Icon(
              Icons.add_circle,
              size: 34,
            ),

            label: "BUAT",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.history_rounded),

            label: "RIWAYAT",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.person_rounded),

            label: "PROFIL",

          ),

        ],

      ),

    );
  }
}