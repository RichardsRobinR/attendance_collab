import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class AddSubjectDetails extends StatefulWidget {
  const AddSubjectDetails({Key? key}) : super(key: key);

  @override
  State<AddSubjectDetails> createState() => _AddSubjectDetailsState();
}

class _AddSubjectDetailsState extends State<AddSubjectDetails> {
  String dropdownValue = "One";
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Collab"),
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
                  Row(
                    children: [
                      const Text("Subject Name: "),
                      const SizedBox(
                        width: 20,
                      ),
                      _provider.droDownListCustom(_provider.subjectList, 1),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Branch Name: "),
                      const SizedBox(
                        width: 20,
                      ),
                      _provider.droDownListCustom(_provider.branchLIst, 2),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Year: "),
                      const SizedBox(
                        width: 20,
                      ),
                      _provider.droDownListCustom(_provider.yearList, 0),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _provider.addSubjects();
            Navigator.pop(context);
          },
          label: Text("Add")),
    );
  }
}
