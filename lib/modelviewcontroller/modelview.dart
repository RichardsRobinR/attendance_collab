import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataModelView extends ChangeNotifier {
  var db = FirebaseFirestore.instance;
  String _userId = ' ';
  String get userId => _userId;

  late Stream<QuerySnapshot> _usersStream;
  Stream<QuerySnapshot> get usersStream => _usersStream;

  late Stream<QuerySnapshot> _studentStream;
  Stream<QuerySnapshot> get studentStream => _studentStream;

  String _studentSubjectName = ' ';
  String get studentSubjectName => _studentSubjectName;

  int _subjectTotalClasses = 0;
  int get subjectTotalClasses => _subjectTotalClasses;

  final List<String> _subjectList = [
    'C Programming',
    'Operating Systems',
    'DBMS',
    'Python'
  ];
  List<String> get subjectList => _subjectList;

  final List<String> _branchLIst = ['BCA', 'Bsc', 'BBA', 'BCom', 'BA'];
  List<String> get branchLIst => _branchLIst;

  final List<int> _yearList = [
    1,
    2,
    3,
  ];
  List<int> get yearList => _yearList;

  String _dropdownSubjectValue = "C Programming";
  String get dropdownSubjectValue => _dropdownSubjectValue;

  String _dropdownBranchValue = "BCA";
  String get dropdownBranchValue => _dropdownBranchValue;

  int _dropdownYearValue = 1;
  int get dropdownYearValue => _dropdownYearValue;

  void setSelectedItemSubject(String s) {
    _dropdownSubjectValue = s;
    notifyListeners();
  }

  void setSelectedItemBranch(String s) {
    _dropdownBranchValue = s;
    notifyListeners();
  }

  void setSelectedItemYear(int s) {
    _dropdownYearValue = s;
    notifyListeners();
  }

  void changeUserStreamValue() {
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('subjects')
        .snapshots();
  }

  void changeStudentDocIdStreamValue(lecturerSubjectName) {
    _studentStream = FirebaseFirestore.instance
        .collection('students')
        .where('student_subjects', arrayContains: lecturerSubjectName)
        .snapshots();
    _studentSubjectName = lecturerSubjectName;
  }

  void changeSubjectTotalClasses(subjectTotalClasses) {
    _subjectTotalClasses = subjectTotalClasses;
  }

  Future<void> signInWithEmailAndPassword(emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      _userId = credential.user!.uid.toString();
      changeUserStreamValue();
      print(_userId);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void addSubjects() {
    final details = <String, dynamic>{
      "branch": _dropdownBranchValue,
      "subject_name": _dropdownSubjectValue,
      "total_classes": 0,
      "year": _dropdownYearValue
    };

    db
        .collection("users")
        .doc(_userId)
        .collection('subjects')
        .add(details)
        .then((documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
  }

  void addStudents() {
    String studentName = "Dolphin Johnson";
    String studentUsnNumber = "SB19000";
    final details = <String, dynamic>{
      "student_name": studentName,
      'student_subjects': [],
      'subject_attended': {},
      "usn_number": studentUsnNumber,
    };

    db
        .collection("students")
        .doc(studentUsnNumber)
        .set(details)
        .onError((e, _) => print("Error writing document: $e"));
  }

  void addStudentsToLecturerSubject() {
    String studentName = "Dolphin Johnson";
    String studentUsnNumber = "SB19000";
    final details = <String, dynamic>{
      "student_name": studentName,
      'student_subjects': [],
      'subject_attended': {},
      "usn_number": studentUsnNumber,
    };

    db
        .collection("students")
        .doc(studentUsnNumber)
        .set(details)
        .onError((e, _) => print("Error writing document: $e"));
  }

  droDownListCustom(itemlist, condition) {
    if (condition == 1) {
      return DropdownButton<dynamic>(
        value: _dropdownSubjectValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        onChanged: (dynamic newValue) {
          setSelectedItemSubject(newValue);
        },
        items: itemlist.map<DropdownMenuItem<dynamic>>((dynamic value) {
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    } else if (condition == 2) {
      return DropdownButton<dynamic>(
        value: _dropdownBranchValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        onChanged: (dynamic newValue) {
          setSelectedItemBranch(newValue);
        },
        items: itemlist.map<DropdownMenuItem<dynamic>>((dynamic value) {
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    } else {
      return DropdownButton<dynamic>(
        value: _dropdownYearValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        onChanged: (dynamic newValue) {
          setSelectedItemYear(newValue);
        },
        items: itemlist.map<DropdownMenuItem<dynamic>>((dynamic value) {
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    }
  }
}
