import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelviewcontroller/modelview.dart';

class FirebaseUserLoginStatus extends StatefulWidget {
  const FirebaseUserLoginStatus({Key? key}) : super(key: key);

  @override
  State<FirebaseUserLoginStatus> createState() =>
      _FirebaseUserLoginStatusState();
}

class _FirebaseUserLoginStatusState extends State<FirebaseUserLoginStatus> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DataModelView>(context, listen: false)
        .checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
