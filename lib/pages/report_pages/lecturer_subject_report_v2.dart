import 'dart:async';

import 'package:attendance_collab/pages/report_pages/student_attendence_report_v2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class LecturerSubjectReport extends StatefulWidget {
  const LecturerSubjectReport({Key? key}) : super(key: key);

  @override
  State<LecturerSubjectReport> createState() => _LecturerSubjectReportState();
}

class _LecturerSubjectReportState extends State<LecturerSubjectReport> {
  var db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _usersStream;

  int _itemCount = 0;

  late Map<String, dynamic> data = {"ok": "s"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DataModelView>(context, listen: false).changeUserStreamValue();
    _usersStream =
        Provider.of<DataModelView>(context, listen: false).usersStream;
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream as Stream<QuerySnapshot>,
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
                  //print(data['total_classes']);
                  // Provider.of<DataModelView>(context,listen: false).changeSubjectTotalClasses(data['total_classes']);

                  return InkWell(
                    onTap: () {
                      _provider
                          .changeStudentDocIdStreamValue(data['subject_name']);
                      // _provider
                      //     .changeSubjectTotalClasses(data['total_classes']);
                      print(data['subject_name']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StudentAttedenceReport()),
                      );
                    },
                    child: ListTile(
                      leading: Text((i = i + 1).toString()),
                      title: Text(data['subject_name'].toString()),
                      subtitle: Text("${data['year']}${data['branch']}"),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            data['total_classes'] != 0
                                ? ElevatedButton(
                                    onPressed: () {
                                      db
                                          .collection('users')
                                          .doc(_provider.userId)
                                          .collection("subjects")
                                          .doc(document.id)
                                          .update({
                                        "total_classes":
                                            data["total_classes"] - 1
                                      });
                                    },
                                    child: Icon(Icons.remove))
                                : Container(),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(data['total_classes'].toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  db
                                      .collection('users')
                                      .doc(_provider.userId)
                                      .collection("subjects")
                                      .doc(document.id)
                                      .update({
                                    "total_classes": data["total_classes"] + 1
                                  });
                                },
                                child: Icon(Icons.add)),
                            PopupMenuButton(itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    child: Text("Delete"),
                                    onTap: () {
                                      deleteDailog(context);
                                    }),
                              ];
                            })
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .toList()
                .cast(),
          );
        });
  }
}

Future deleteDailog(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are You Sure?'),
        content: Text('Do you want to delete the student '),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('DELETE'),
          ),
        ],
      );
    },
  );
}
