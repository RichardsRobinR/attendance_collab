import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/lecturer_login.dart';
import '../widgets/custom_navigatio_bar.dart';

class DataModelView extends ChangeNotifier {
  var db = FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  String _onlyDate = ' ';

  String get onlyDate => _onlyDate;

  int _lecturerSubjectYear = 0;
  int get lecturerSubjectYear => _lecturerSubjectYear;

  String _lecturerSubjectBranch = ' ';
  String get lecturerSubjectBranch => _lecturerSubjectBranch;

  final List<String> _subjectList = [
    'C Programming',
    'Operating Systems',
    'DBMS',
    'Python',
    'Java',
    'C',
    'Economics',
    'Statistics'
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

  void setlecturerSubjectYearAndBranch(year, branch) {
    _lecturerSubjectYear = year;
    _lecturerSubjectBranch = branch;
  }

  void setUserId(user_id) {
    _userId = user_id;
    print("id :" + _userId);
    changeUserStreamValue();
  }

  void setDefaultDate() {
    _onlyDate = "${_selectedDate.toLocal()}".split(' ')[0];
  }

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

  void setStudentSubjectName(lecturerSubjectName) {
    _studentSubjectName = lecturerSubjectName;
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

  Future<void> signInWithEmailAndPassword(
      emailAddress, password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      _userId = credential.user!.uid.toString();
      changeUserStreamValue();
      print(_userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomNavigationBar()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void checkLoginStatus(context) async {
    await _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LecturerLogin()),
        );
      } else {
        print('User is signed in!');
        setUserId(user.uid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
        );
      }
    });
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _onlyDate = "${_selectedDate.toLocal()}".split(' ')[0];
      notifyListeners();
    }
  }

  void setDateToFalseDefault(docSubjectId) {
    final details = <String, dynamic>{
      'subject_attended_v2': {
        _studentSubjectName: {_onlyDate: false}
      },
    };

    db
        .collection('students')
        .doc(docSubjectId)
        .set(details, SetOptions(merge: true));
    //notifyListeners();
  }

  void callSetDateToFalseDefaultFun() {
    db.collection('students').get().then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        Map<dynamic, dynamic> subject_attended_v2 = data['subject_attended_v2'];

        Map<dynamic, dynamic> subject_of_dates =
            subject_attended_v2[_studentSubjectName];

        print(data["usn_number"]);
        if (subject_of_dates.length == 0) {
          setDateToFalseDefault(data['usn_number']);
        } else {
          subject_of_dates.forEach((key, value) {
            if (key != _onlyDate) {
              setDateToFalseDefault(data['usn_number']);
            }
          });
        }
      }
    });
  }

  void updateAttendenceCheckBoxList(docId, value) {
    final details = <String, dynamic>{
      'subject_attended_v2': {
        _studentSubjectName: {_onlyDate: value}
      },
    };

    db.collection('students').doc(docId).set(details, SetOptions(merge: true));
  }
}
