import 'package:attendance_collab/modelviewcontroller/modelview.dart';
import 'package:attendance_collab/pages/lecturer_subject_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerLogin extends StatefulWidget {
  const LecturerLogin({Key? key}) : super(key: key);

  @override
  State<LecturerLogin> createState() => _LecturerLoginState();
}

class _LecturerLoginState extends State<LecturerLogin> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DataModelView>(context,listen: false).signInWithEmailAndPassword("test@gmail.com", "123456");
    //Provider.of<DataModelView>(context,listen: false).createSubjects();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Rewardio"),
        //backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {


            },
          ),
        ],
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LecturerSubjectDetails()),
            );

          },
          child: Text("Click"),
        ),
      ),
    );
  }
}
