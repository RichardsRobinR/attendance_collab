import 'dart:async';

import 'package:attendance_collab/pages/form_pages/add_student_details.dart';
import 'package:attendance_collab/pages/form_pagesV2/attendence_page_V2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';

class LecturerSubjectDetailsV2 extends StatefulWidget {
  const LecturerSubjectDetailsV2({Key? key}) : super(key: key);

  @override
  State<LecturerSubjectDetailsV2> createState() =>
      _LecturerSubjectDetailsV2State();
}

class _LecturerSubjectDetailsV2State extends State<LecturerSubjectDetailsV2> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Collab"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // return const Text("Loading");
              return CircularProgressIndicator();
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
                        _provider.changeStudentDocIdStreamValue(
                            data['subject_name']);
                        _provider.setlecturerSubjectYearAndBranch(
                            data['year'], data['branch']);
                        print(data['subject_name']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AttendencePage()),
                        );
                      },
                      child: ListTile(
                        leading: Text((i = i + 1).toString()),
                        title: Text(data['subject_name'].toString()),
                        subtitle: Text("${data['year']}${data['branch']}"),
                        trailing: PopupMenuButton(onSelected: (val) {
                          if (val == 0) {
                            _provider
                                .setStudentSubjectName(data['subject_name']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddStudentDetails()),
                            );
                          }
                        }, itemBuilder: (context) {
                          return const [
                            // PopupMenuItem(
                            //     child: Text("Delete"),
                            //     onTap: () {
                            //       deleteDailog(context);
                            //     }),
                            PopupMenuItem(
                              child: Text("Add Student"),
                              value: 0,
                            )
                          ];
                        }),
                      ),
                    );
                  })
                  .toList()
                  .cast(),
            );
          }),
    );
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
