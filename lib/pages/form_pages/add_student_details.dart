import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class AddStudentDetails extends StatefulWidget {
  const AddStudentDetails({Key? key}) : super(key: key);

  @override
  State<AddStudentDetails> createState() => _AddStudentDetailsState();
}

class _AddStudentDetailsState extends State<AddStudentDetails> {
  String dropdownValue = "One";
  var db = FirebaseFirestore.instance;

  final studentNameController = TextEditingController();
  final studentUsnNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    studentNameController.dispose();
    studentUsnNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward Points"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child:
                Consumer<DataModelView>(builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: studentNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Student FullName',
                    ),
                  ),
                  TextFormField(
                    controller: studentUsnNumberController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Student USN Number',
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _provider.addStudents(studentNameController.text,
                studentUsnNumberController.text.toUpperCase());
            Navigator.pop(context);
          },
          label: Text("Add")),
    );
  }
}
