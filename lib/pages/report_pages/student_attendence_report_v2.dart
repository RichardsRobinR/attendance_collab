import 'dart:async';

import 'package:attendance_collab/pages/form_pages/add_student_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class StudentAttedenceReport extends StatefulWidget {
  const StudentAttedenceReport({Key? key}) : super(key: key);

  @override
  State<StudentAttedenceReport> createState() => _StudentAttedenceReportState();
}

class _StudentAttedenceReportState extends State<StudentAttedenceReport> {
  var db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _studentStream;
  int subjectAttendedTrueCount = 0;
  Map<dynamic, dynamic> subject_attended_v2_studentSubjectName = {};

  late Map<String, dynamic> data = {"ok": "s"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DataModelView>(context, listen: false);
    _studentStream =
        Provider.of<DataModelView>(context, listen: false).studentStream;
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _studentStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              //return const Text("Loading");
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    Map<dynamic, dynamic> subject_attended_v2 =
                        data['subject_attended_v2'];

                    subjectAttendedTrueCount = 0;
                    subject_attended_v2.forEach((key, value) {
                      if (key == _provider.studentSubjectName) {
                        subject_attended_v2_studentSubjectName =
                            subject_attended_v2[_provider.studentSubjectName];
                        subject_attended_v2_studentSubjectName
                            .forEach((key, value) {
                          if (value == true) {
                            subjectAttendedTrueCount =
                                subjectAttendedTrueCount + 1;
                          }
                        });
                        //subject_attended_v2_studentSubjectName.length;
                      }
                    });

                    //print(data['subject_attended_v2'].toString());
                    // if (data['subject_attended_v2'] ==
                    //     _provider.studentSubjectName) {
                    //   print(data['subject_attended_v2']
                    //       [_provider.studentSubjectName]);
                    // }
                    // return ListTile(
                    //   leading: Text((i = i + 1).toString()),
                    //   title: Text(data['student_name'].toString()),
                    //   subtitle: Text(data['usn_number'].toString()),
                    //   // trailing:  Text(
                    //   //     "${data['subject_attended'][_provider.studentSubjectName]}"
                    //   //         "/"
                    //   //         "${_provider.subjectTotalClasses}"),
                    //   trailing: const Text("data"),
                    // );

                    return buildStudentDetailsCard(
                        context,
                        data,
                        subject_attended_v2_studentSubjectName,
                        subjectAttendedTrueCount);
                  })
                  .toList()
                  .cast(),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Add Students"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddStudentDetails()),
            );
          },
          icon: Icon(Icons.add)),
    );
  }
}

buildStudentDetailsCard(BuildContext context, data,
    subject_attended_v2_studentSubjectName, subjectAttendedTrueCount) {
  return Card(
    elevation: 5,
    shadowColor: Colors.grey[200],
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      data['usn_number'].toString(),
                      // Enrollment[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    Text(
                      data['student_name'].toString(),
                      // Students[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    const Text(
                      'studentemail',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Branch :  ${data['branch']}",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "Year :  ${data['year']}",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "Present :  ${subjectAttendedTrueCount} / ${subject_attended_v2_studentSubjectName.length}",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
