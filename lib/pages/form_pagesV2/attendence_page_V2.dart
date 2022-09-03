import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelviewcontroller/modelview.dart';
import 'add_student_attendence.dart';

class AttendencePage extends StatefulWidget {
  const AttendencePage({Key? key}) : super(key: key);

  @override
  State<AttendencePage> createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  bool buttonState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DataModelView>(context, listen: false).setDefaultDate();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Attendence"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _provider.onlyDate,
                            style: TextStyle(fontSize: 30),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _provider.selectDate(context);
                            },
                            child: const Text(
                              "Select Date",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Subject : ${_provider.studentSubjectName}",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Branch : ${_provider.lecturerSubjectBranch}",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Year : ${_provider.lecturerSubjectYear}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              buttonState
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => AddStudentAttendence()),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 50),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Provider.of<DataModelView>(context, listen: false)
                            .callSetDateToFalseDefaultFun();
                        setState(() {
                          buttonState = true;
                        });
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
