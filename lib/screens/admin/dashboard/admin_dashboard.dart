import 'package:flutter/material.dart';

import '../home/admin_home_screen.dart';
import '../request/admin_request_screen.dart';
import '../report/admin_report_screen.dart';
import '../user/admin_user_screen.dart';
import '../profile/admin_profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {

  int currentIndex = 0;

  final pages = const [

    AdminHomeScreen(),

    AdminRequestScreen(),

    AdminReportScreen(),

    AdminUserScreen(),

    AdminProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xffB08968),

        unselectedItemColor: Colors.grey,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "BERANDA",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: "PERMINTAAN",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: "LAPORAN",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: "PENGGUNA",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "PROFIL",
          ),

        ],

      ),

    );

  }

}