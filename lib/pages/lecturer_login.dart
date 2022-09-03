import 'package:attendance_collab/modelviewcontroller/modelview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerLogin extends StatefulWidget {
  const LecturerLogin({Key? key}) : super(key: key);

  @override
  State<LecturerLogin> createState() => _LecturerLoginState();
}

class _LecturerLoginState extends State<LecturerLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<DataModelView>(context, listen: false)
    //     .signInWithEmailAndPassword("test@gmail.com", "123456");
    //Provider.of<DataModelView>(context,listen: false).createSubjects();
  }

  bool loadingStatus = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Collab"),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      // body: Container(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => const CustomNavigationBar()),
      //       );
      //     },
      //     child: Text("Click"),
      //   ),
      // ),

      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              loadingStatus
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          Provider.of<DataModelView>(context, listen: false)
                              .signInWithEmailAndPassword(nameController.text,
                                  passwordController.text, context);
                          setState(() {
                            loadingStatus = true;
                          });
                        },
                      )),
            ],
          )),
    );
  }
}
