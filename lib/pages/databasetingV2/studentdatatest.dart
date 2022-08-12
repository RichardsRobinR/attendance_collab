import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentDataTest extends StatefulWidget {
  const StudentDataTest({Key? key}) : super(key: key);

  @override
  State<StudentDataTest> createState() => _StudentDataTestState();
}

class _StudentDataTestState extends State<StudentDataTest> {
  var db = FirebaseFirestore.instance;
  final _studentStream = FirebaseFirestore.instance
      .collection('students')
      .where('002.students_subjects', arrayContains: 'DBMS')
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hello");
    // db.collection('students').doc('N6BQHdNKgVV1AMxYkdNM').update({
    //   'test': FieldValue.arrayUnion(['list5'])
    // });
    // final docRef = db
    //     .collection('students')
    //     .where('students_subects', arrayContains: "python")
    //     .get()
    //     .then(
    //   (res) {
    //     print(res.docs);
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
    //
    // print(docRef);

    // docRef.get().then(
    //   (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //
    //     print(data['001']['students_subects'][1]);
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
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
            onPressed: () {},
          ),
        ],
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
                    print(data.keys);
                    return ListTile(
                      leading: Text((i = i + 1).toString()),
                      title: Text(data['test'][0].toString()),
                      subtitle: Text('test'.toString()),
                    );
                  })
                  .toList()
                  .cast(),
            );
          }),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}
