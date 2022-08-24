import 'package:flutter/material.dart';

class StudentAboutPage extends StatefulWidget {
  const StudentAboutPage({Key? key}) : super(key: key);

  @override
  _StudentAboutPageState createState() => _StudentAboutPageState();
}

class _StudentAboutPageState extends State<StudentAboutPage> {
  final studentvar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: 150,
            itemBuilder: (BuildContext context, int index) =>
                buildStudentDetailsCard(context, index)),
      ),
      // ),
    );
  }

  buildStudentDetailsCard(BuildContext context, int index) {
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
                    children: const [
                      Text(
                        'studentEnrollmentNo',
                        // Enrollment[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      Text(
                        'studentName',
                        // Students[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      Text(
                        'studentemail',
                        // StudentEmail[index],
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
              children: const [
                Text(
                  "Branch :  branch",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "Year :  studingInYear",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
