import 'package:attendance_collab/modelviewcontroller/modelview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navigatio_bar.dart';

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
    Provider.of<DataModelView>(context, listen: false)
        .signInWithEmailAndPassword("test@gmail.com", "123456");
    //Provider.of<DataModelView>(context,listen: false).createSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Collab"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomNavigationBar()),
            );
          },
          child: Text("Click"),
        ),
      ),
    );
  }
}
