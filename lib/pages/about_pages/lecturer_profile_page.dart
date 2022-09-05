import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LecturerProfilePage extends StatefulWidget {
  const LecturerProfilePage({Key? key}) : super(key: key);

  @override
  _LecturerProfilePageState createState() => _LecturerProfilePageState();
}

class _LecturerProfilePageState extends State<LecturerProfilePage> {
  String profileImageUrl =
      "https://media.istockphoto.com/vectors/user-icon-human-person-symbol-social-profile-icon-avatar-login-sign-vector-id1316420668?k=20&m=1316420668&s=612x612&w=0&h=Z2cc0HZXkovLCVmoJ8LCIG5eWMetgOX9oLe-lF0OWJM=";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Staff Profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ))),
          // DisplayImage(
          //   imagePath: user.image,
          //   onPressed: () {},
          // ),
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
            radius: 75,
          ),
          buildUserInfoDisplay(
            'Demo User',
            'Name',
          ),
          buildUserInfoDisplay(
            '976543210',
            'Phone',
          ),
          buildUserInfoDisplay(
            'test@gmail.com',
            'Email',
          ),
          ElevatedButton(
              onPressed: () {
                signOut();
              },
              child: Text("Sign Out"))
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(
    String getValue,
    String title,
  ) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Text(
                  getValue,
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
              )
            ],
          ));
}
