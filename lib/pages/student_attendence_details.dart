import 'package:attendance_collab/pages/form_pages/add_student_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelviewcontroller/modelview.dart';

class StudentAttedenceDetails extends StatefulWidget {
  const StudentAttedenceDetails({Key? key}) : super(key: key);

  @override
  State<StudentAttedenceDetails> createState() =>
      _StudentAttedenceDetailsState();
}

class _StudentAttedenceDetailsState extends State<StudentAttedenceDetails> {
  var db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _studentStream;

  int _itemCount = 0;

  late Map<String, dynamic> data = {"ok": "s"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studentStream =
        Provider.of<DataModelView>(context, listen: false).studentStream;
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
          stream: _studentStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            int i = 0;
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      leading: Text((i = i + 1).toString()),
                      title: Text(data['student_name'].toString()),
                      subtitle: Text(data['usn_number'].toString()),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            data['subject_attended']
                                        [_provider.studentSubjectName] !=
                                    0
                                ? ElevatedButton(
                                    onPressed: () {
                                      Map<String, dynamic> updateSubjectVAlue =
                                          {
                                        'Python': data['subject_attended']
                                                [_provider.studentSubjectName] -
                                            1
                                      };
                                      Map<String, dynamic> updatedData = {
                                        'subject_attended': updateSubjectVAlue,
                                      };

                                      db
                                          .collection('students')
                                          .doc(data['usn_number'])
                                          .update(updatedData);
                                    },
                                    child: Icon(Icons.remove))
                                : Container(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${data['subject_attended'][_provider.studentSubjectName]}"
                                "/"
                                "${_provider.subjectTotalClasses}"),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Map<String, dynamic> updateSubjectVAlue = {
                                    'Python': data['subject_attended']
                                            [_provider.studentSubjectName] +
                                        1
                                  };
                                  Map<String, dynamic> updatedData = {
                                    'subject_attended': updateSubjectVAlue,
                                  };

                                  db
                                      .collection('students')
                                      .doc(data['usn_number'])
                                      .update(updatedData);
                                },
                                child: Icon(Icons.add)),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList()
                  .cast(),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddStudentDetails()),
            );
          },
          child: Icon(Icons.add)),
    );
  }
}
