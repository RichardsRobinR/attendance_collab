import 'package:attendance_collab/pages/about_pages/lecturer_profile_page.dart';
import 'package:flutter/material.dart';

import '../pages/form_pagesV2/lecturer_subject_details_V2.dart';
import '../pages/report_pages/lecturer_subject_report_v2.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentPageIndex = 0;

  // String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'Attendence',
          ),
          NavigationDestination(
            icon: Icon(Icons.description),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        LecturerSubjectDetailsV2(),
        // Container(
        //   color: Colors.red,
        //   alignment: Alignment.center,
        //   child: const Text('Page 1'),
        // ),
        LecturerSubjectReport(),
        // StudentAboutPage(),
        LecturerProfilePage(),
      ][currentPageIndex],
    );
  }
}
