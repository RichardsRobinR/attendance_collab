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
  var db = FirebaseFirestore.instance;
  bool stateValue = false;
  Map<String, bool> student_subjects_map = {};

  final Stream<QuerySnapshot> _studentListStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.transparent,
      ),
      // body: Center(
      //   child: Container(
      //     child: Padding(
      //       padding: const EdgeInsets.all(64.0),
      //       child:
      //           Consumer<DataModelView>(builder: (context, viewModel, child) {
      //         return Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             TextFormField(
      //               controller: studentNameController,
      //               decoration: const InputDecoration(
      //                 border: UnderlineInputBorder(),
      //                 labelText: 'Enter Student FullName',
      //               ),
      //             ),
      //             TextFormField(
      //               controller: studentUsnNumberController,
      //               decoration: const InputDecoration(
      //                 border: UnderlineInputBorder(),
      //                 labelText: 'Enter Student USN Number',
      //               ),
      //             ),
      //           ],
      //         );
      //       }),
      //     ),
      //   ),
      // ),
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

                    print(student_subjects.length);

                    if (student_subjects.length != 0) {
                      for (int j = 0; j < student_subjects.length; j++) {
                        if (_provider.studentSubjectName ==
                            student_subjects[j]) {
                          stateValue = true;
                        }
                      }

                      if (stateValue == true) {
                        student_subjects_map.addAll({data['usn_number']: true});
                        stateValue = false;
                      } else {
                        student_subjects_map
                            .addAll({data['usn_number']: false});
                      }
                    } else {
                      student_subjects_map.addAll({data['usn_number']: false});
                    }

                    print(student_subjects_map[data['usn_number']]);
                    print(student_subjects_map.toString());
                    return student_subjects_map.isEmpty
                        ? const CircularProgressIndicator()
                        : CheckboxListTile(
                            title: Text(data['student_name'].toString()),
                            value: student_subjects_map[data['usn_number']],
                            onChanged: (val) {
                              setState(
                                () {
                                  if (val == true) {
                                    student_subjects_map[data['usn_number']] =
                                        val!;
                                    db
                                        .collection('students')
                                        .doc(data['usn_number'])
                                        .update({
                                      'student_subjects': FieldValue.arrayUnion(
                                          [_provider.studentSubjectName])
                                    });

                                    final details = <String, dynamic>{
                                      'subject_attended_v2': {
                                        _provider.studentSubjectName: {}
                                      },
                                    };

                                    db
                                        .collection('students')
                                        .doc(data['usn_number'])
                                        .set(details, SetOptions(merge: true));
                                  } else {
                                    student_subjects_map[data['usn_number']] =
                                        val!;
                                    db
                                        .collection('students')
                                        .doc(data['usn_number'])
                                        .update({
                                      'student_subjects':
                                          FieldValue.arrayRemove(
                                              [_provider.studentSubjectName])
                                    });
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
