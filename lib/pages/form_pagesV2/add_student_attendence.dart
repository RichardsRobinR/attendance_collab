import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class AddStudentAttendence extends StatefulWidget {
  const AddStudentAttendence({Key? key}) : super(key: key);

  @override
  State<AddStudentAttendence> createState() => _AddStudentAttendenceState();
}

class _AddStudentAttendenceState extends State<AddStudentAttendence> {
  var db = FirebaseFirestore.instance;
  bool stateValue = false;

  late final Stream<QuerySnapshot> _studentListStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studentListStream =
        Provider.of<DataModelView>(context, listen: false).studentStream;
    print(
        "selected date :${Provider.of<DataModelView>(context, listen: false).selectedDate}");
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Collab"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _studentListStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    List<dynamic> student_subjects = data['student_subjects'];
                    Map<dynamic, dynamic> subject_attended_v2 =
                        data['subject_attended_v2'];

                    Map<dynamic, dynamic> subject_of_dates =
                        subject_attended_v2[_provider.studentSubjectName];

                    print(student_subjects.length);

                    return CheckboxListTile(
                      title: Text(data['student_name'].toString()),
                      value: subject_of_dates[_provider.onlyDate],
                      onChanged: (val) {
                        setState(
                          () {
                            if (val == true) {
                              _provider.updateAttendenceCheckBoxList(
                                  data['usn_number'], true);
                            } else {
                              _provider.updateAttendenceCheckBoxList(
                                  data['usn_number'], false);
                            }
                          },
                        );
                      },
                    );
                  })
                  .toList()
                  .cast(),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text("Add")),
    );
  }
}
